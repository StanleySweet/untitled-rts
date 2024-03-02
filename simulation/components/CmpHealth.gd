# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends ICmpHealth
class_name CmpHealth

@export var template : CmpHealthSchema

var maxHitpoints : float
var hitpoints : float
var regenRate : float
var idleRegenRate : float

func _ready():
	# Cache this value so it allows techs to maintain previous health level
	self.maxHitpoints = self.template.Max;
	# Default to <Initial>, but use <Max> if it's undefined or zero
	# (Allowing 0 initial HP would break our death detection code)
	self.hitpoints = self.template.Initial if self.template.Initial != -1 else self.maxHitpoints;
	self.regenRate = ValueModification.apply_to_entity("Health/RegenRate", self.template.RegenRate, self.entity);
	self.idleRegenRate = ValueModification.apply_to_entity("Health/IdleRegenRate", self.template.IdleRegenRate, self.entity);
	self.check_regen_timer();
	self.update_actor();

func get_hitpoints():
	return self.hitpoints;

func get_max_hitpoints():
	return self.maxHitpoints;

func is_injured():
	return self.hitpoints > 0 && self.hitpoints < self.get_max_hitpoints();

func set_hitpoints(value):
	# If we're already dead, don't allow resurrection
	if (self.hitpoints == 0):
		return;

	# Before changing the value, activate Fogging if necessary to hide changes
	var cmpFogging : ICmpFogging = PyrogenesisEngine.query_interface(self.entity, ICmpFogging.IID);
	if (cmpFogging):
		cmpFogging.activate();

	var old = self.hitpoints;
	self.hitpoints = max(1, min(self.get_max_hitpoints(), value));

	var cmpRangeManager = PyrogenesisEngine.query_interface(PyrogenesisEngine.SYSTEM_ENTITY,ICmpRangeManager.IID);
	if (cmpRangeManager):
		cmpRangeManager.SetEntityFlag(self.entity, "injured", self.is_injured());

	self.register_health_changed(old);

func check_regen_timer():
	pass

func update_actor():
	pass
	
func register_health_changed(old : float):
	pass
