# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends ICmpAlertRaiser
class_name CmpAlertRaiser

@export var template : CmpAlertRaiserSchema

var lastTime : float;

func _ready():
	self.lastTime = 0;

func get_target_classes() -> PackedStringArray:
	return self.template.List

func unit_filter(unit : int) -> bool:
	var cmpIdentity : ICmpIdentity = PyrogenesisEngine.query_interface(unit, ICmpIdentity.IID);
	return cmpIdentity != null && ICmpTemplateManager.matches_class_list(cmpIdentity.get_classes_list(), self.get_target_classes());

func raise_alert():
	var cmpTimer : ICmpTimer = PyrogenesisEngine.query_interface(PyrogenesisEngine.SYSTEM_ENTITY, ICmpTimer.IID);
	if cmpTimer.get_time() == self.lastTime:
		return

	self.lastTime = cmpTimer.get_time();
	ICmpSoundManager.play_sound("alert_raise", self.entity);

	var cmpOwnership : ICmpOwnership = PyrogenesisEngine.query_interface(self.entity, ICmpOwnership.IID);
	if !cmpOwnership || cmpOwnership.get_owner_id() == PlayerHelper.INVALID_PLAYER:
		return;

	var ownerId = cmpOwnership.get_owner_id();
	var cmpDiplomacy : ICmpDiplomacy = PlayerHelper.query_player_id_interface(ownerId, ICmpDiplomacy.IID);
	var mutualAllies = cmpDiplomacy.get_mutual_allies() if cmpDiplomacy else [owner];
	var cmpRangeManager : ICmpRangeManager = PyrogenesisEngine.query_interface(PyrogenesisEngine.SYSTEM_ENTITY, ICmpRangeManager.IID);
	var reserved : Dictionary = {}
	var units = cmpRangeManager.execute_query(self.entity, 0, self.template.RaiseAlertRange, [ownerId], ICmpUnitAI.IID, true)
	var filteredUnits = []
	for unit in units:
		if self.unit_filter(unit):
			filteredUnits.append(unit)

	for unit in filteredUnits:
		var cmpGarrisonable : ICmpGarrisonable = PyrogenesisEngine.query_interface(unit, ICmpGarrisonable.IID);
		if not cmpGarrisonable:
			continue
		
		var size : int = cmpGarrisonable.total_size();
		var cmpUnitAI : ICmpUnitAI = PyrogenesisEngine.query_interface(unit, ICmpUnitAI.IID);
		var possibleHolders = cmpRangeManager.execute_query(unit, 0, self.template.SearchRange, mutualAllies, ICmpGarrisonHolder.IID, true)
		
		var holderId = null
		for holder in possibleHolders:
			# Ignore moving garrison holders
			if PyrogenesisEngine.query_interface(holder, ICmpUnitAI.IID):
				continue

			# Ensure that the garrison holder is within range of the alert raiser
			if self.template.EndOfAlertRange > 0 && PositionHelper.distance_between_entities(self.entity, holder) > self.template.EndOfAlertRange:
				continue

			if !cmpUnitAI.CheckTargetVisible(holder):
				continue

			var cmpGarrisonHolder : ICmpGarrisonHolder = PyrogenesisEngine.query_interface(holder, ICmpGarrisonHolder.IID);
			if !reserved.has(holder):
				reserved[holder] = cmpGarrisonHolder.GetCapacity() - cmpGarrisonHolder.OccupiedSlots();

			holderId =  cmpGarrisonHolder.is_allowed_to_garrison(unit) && reserved.get(holder) >= size;


		if holderId:
			reserved[holderId] = reserved.get(holderId) - size;
			cmpUnitAI.garrison(holderId, false, false);
		else:
			# If no available spots, stop moving
			cmpUnitAI.replace_order("Stop", { "force": true });

func end_of_alert():
	var cmpTimer : ICmpTimer = PyrogenesisEngine.query_interface(PyrogenesisEngine.SYSTEM_ENTITY, ICmpTimer.IID);
	if cmpTimer.get_time() == self.lastTime:
		return;

	self.lastTime = cmpTimer.get_time();
	ICmpSoundManager.play_sound("alert_end", self.entity);

	var cmpOwnership : ICmpOwnership = PyrogenesisEngine.query_interface(self.entity, ICmpOwnership.IID);
	if (!cmpOwnership || cmpOwnership.get_owner_id() == PlayerHelper.INVALID_PLAYER):
		return;

	var ownerId = cmpOwnership.get_owner_id();
	var cmpDiplomacy : ICmpDiplomacy = PlayerHelper.query_player_id_interface(ownerId, ICmpDiplomacy.IID);
	var mutualAllies = cmpDiplomacy.get_mutual_allies() if cmpDiplomacy else [ownerId];
	var cmpRangeManager = PyrogenesisEngine.query_interface(PyrogenesisEngine.SYSTEM_ENTITY, ICmpRangeManager.IID);

	# Units that are not garrisoned should go back to work
	var units = cmpRangeManager.ExecuteQuery(self.entity, 0, self.template.EndOfAlertRange, [ownerId], ICmpUnitAI.IID, true)
	
	var filteredUnits = []
	for unit in units:
		if self.unit_filter(unit):
			filteredUnits.append(unit)

	for unit in filteredUnits:
		var cmpUnitAI = PyrogenesisEngine.query_interface(unit, ICmpUnitAI.IID);
		if (cmpUnitAI.HasWorkOrders() && cmpUnitAI.ShouldRespondToEndOfAlert()):
			cmpUnitAI.BackToWork();
		elif (cmpUnitAI.ShouldRespondToEndOfAlert()):
			# Stop rather than continue to try to garison
			cmpUnitAI.ReplaceOrder("Stop", { "force": true });

	# Units that are garrisoned should ungarrison and go back to work
	var holders : PackedInt32Array = cmpRangeManager.ExecuteQuery(self.entity, 0, self.template.EndOfAlertRange, mutualAllies, ICmpGarrisonHolder.IID, true);
	if PyrogenesisEngine.query_interface(self.entity, ICmpGarrisonHolder.IID):
		holders.append(self.entity);

	for holder in holders:
		if PyrogenesisEngine.query_interface(holder, ICmpUnitAI.IID):
			continue;

		var cmpGarrisonHolder = PyrogenesisEngine.query_interface(holder, ICmpGarrisonHolder.IID);
		var garrisonedUnits = cmpGarrisonHolder.GetEntities()
		var filteredGarrisonedUnits = []
		for unit in garrisonedUnits:
			var cmpOwner = PyrogenesisEngine.query_interface(unit, ICmpOwnership.IID);
			if cmpOwner && cmpOwner.get_owner_id() == owner && self.unit_filter(unit):
				filteredGarrisonedUnits.append(unit)    

		for unit in garrisonedUnits:
			if (cmpGarrisonHolder.Unload(unit)):
				var cmpUnitAI = PyrogenesisEngine.query_interface(unit, ICmpUnitAI.IID);
				if (cmpUnitAI.has_work_orders()):
					cmpUnitAI.back_to_work();
				else:
					# Stop rather than walk to the rally point
					cmpUnitAI.replace_order("Stop", { "force": true })
