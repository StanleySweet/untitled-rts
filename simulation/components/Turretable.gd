# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends ITurretable

var IID_TurretHolder = ITurretHolder.IID_TurretHolder
var IID_Obstruction = IObstruction.IID_Obstruction
var IID_UnitMotion = IUnitMotion.IID_UnitMotion
var IID_UnitAI = IUnitAI.IID_UnitAI
var IID_Position = IPosition.IID_Position
var IID_RallyPoint = IRallyPoint.IID_RallyPoint

@export var holder: int
@export var is_ejectable: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	self.holder = PyrogenesisEngine.INVALID_ENTITY
	self.is_ejectable = false
	
func get_range(_type, target : int):
	var cmpTurretHolder = PyrogenesisEngine.QueryInterface(target, IID_TurretHolder)
	return cmpTurretHolder.LoadingRange() if cmpTurretHolder else { "min": 0, "max": 1 };

func is_turreted() -> bool:
	return self.holder != PyrogenesisEngine.INVALID_ENTITY
	
func can_occupy(target : int) -> bool:
	if self.holder != PyrogenesisEngine.INVALID_ENTITY:
		return false
	
	var cmpTurretHolder = PyrogenesisEngine.QueryInterface(target, IID_TurretHolder);
	return cmpTurretHolder && cmpTurretHolder.CanOccupy(self.entity);

func occupy_turret(target : int, turretPointName : String, ejectable = true):
	if !self.can_occupy(target):
		return false
		
	var cmpTurretHolder = PyrogenesisEngine.QueryInterface(target, IID_TurretHolder);
	if !cmpTurretHolder || !cmpTurretHolder.occupy_named_turretPoint(self.entity, turretPointName):
		return

	self.holder = target;
	self.is_ejectable = ejectable;

	var cmpUnitAI = PyrogenesisEngine.QueryInterface(self.entity, IID_UnitAI)
	if cmpUnitAI:
		cmpUnitAI.set_turret_stance();

	var cmpUnitMotion = PyrogenesisEngine.QueryInterface(self.entity, IID_UnitMotion)
	if cmpUnitMotion:
		cmpUnitMotion.set_face_point_after_move(false);

	# Remove the unit's obstruction to avoid interfering with pathing.
	var cmpObstruction = PyrogenesisEngine.QueryInterface(self.entity, IID_Obstruction)
	if cmpObstruction:
		cmpObstruction.SetActive(false);

	PyrogenesisEngine.post_message(self.entity, MT_TurretedStateChanged, {
		"oldHolder": PyrogenesisEngine.INVALID_ENTITY,
		"holderID": target
	});

	return true;

func leave_turret(forced : bool = false):
	if self.holder == PyrogenesisEngine.INVALID_ENTITY:
		return true
		
	if !self.is_ejectable && !forced:
		return false

	var pos = PositionHelper.get_spawn_position(self.holder, self.entity, forced)
	if (!pos):
		return false;

	var cmpTurretHolder = PyrogenesisEngine.QueryInterface(self.holder, IID_TurretHolder);
	if (!cmpTurretHolder || !cmpTurretHolder.LeaveTurretPoint(self.entity, forced)):
		return false;

	var cmpUnitMotionEntity = PyrogenesisEngine.QueryInterface(self.entity, IID_UnitMotion);
	if (cmpUnitMotionEntity):
		cmpUnitMotionEntity.SetFacePointAfterMove(true);

	var cmpPosition = PyrogenesisEngine.QueryInterface(self.entity, IID_Position);
	if cmpPosition:
		cmpPosition.SetTurretParent(PyrogenesisEngine.INVALID_ENTITY, Vector3())
		cmpPosition.JumpTo(pos.x, pos.z);
		cmpPosition.SetHeightOffset(0);

		var cmpHolderPosition = PyrogenesisEngine.QueryInterface(self.holder, IID_Position);
		if cmpHolderPosition:
			cmpPosition.SetYRotation(cmpHolderPosition.GetPosition().horizAngleTo(pos));

	var cmpUnitAI = PyrogenesisEngine.QueryInterface(self.entity, IID_UnitAI);
	if (cmpUnitAI):
		cmpUnitAI.Ungarrison();
		cmpUnitAI.ResetTurretStance();

	# Reset the obstruction flags to template defaults.
	var cmpObstruction = PyrogenesisEngine.QueryInterface(self.entity, IID_Obstruction);
	if cmpObstruction:
		cmpObstruction.SetActive(true);

	PyrogenesisEngine.post_message(self.entity, MT_TurretedStateChanged, {
		"oldHolder": self.holder,
		"holderID": PyrogenesisEngine.INVALID_ENTITY
	});

	var cmpRallyPoint = PyrogenesisEngine.QueryInterface(self.holder, IID_RallyPoint);

	# Need to delete this before ordering to a rally
	# point else we may not occupy another turret point.
	self.holder = PyrogenesisEngine.INVALID_ENTITY

	if cmpRallyPoint:
		cmpRallyPoint.OrderToRallyPoint(self.entity, ["occupy-turret"]);

	self.is_ejectable = false
	return true;


func on_entity_renamed(msg) -> void:
	if self.holder == PyrogenesisEngine.INVALID_ENTITY:
		return

	var cmpTurretHolder = PyrogenesisEngine.QueryInterface(self.holder, IID_TurretHolder);
	if !cmpTurretHolder:
		return;

	var previous_holder = self.holder
	var currentPoint = cmpTurretHolder.GetOccupiedTurretPointName(self.entity);
	self.leave_turret(true);
	var cmpTurretableNew = PyrogenesisEngine.QueryInterface(msg.newentity, IID_Turretable);
	if cmpTurretableNew:
		cmpTurretableNew.OccupyTurret(previous_holder, currentPoint);

func on_ownership_changed(msg) -> void:
	if self.holder == PyrogenesisEngine.INVALID_ENTITY:
		return
		
	if msg.to == PyrogenesisEngine.INVALID_ENTITY:
		self.leave_turret(true)
	elif !OwnershipHelper.is_owned_by_mutual_ally_of_entity(self.entity, self.holder):
		self.leave_turret()
	
