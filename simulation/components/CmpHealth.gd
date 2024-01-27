# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends ICmpHealth
class_name CmpHealth

enum EDeathType {
	## Disappear instantly
	Vanish,
	## Turn into a corpse
	Corpse,
	## Remain in the world with 0 health
	Remain
}

## Maximum hitpoints.
@export var Max : float

## Initial hitpoints. Default if unspecified is equal to Max.
@export var Initial : float = -1

## List of variants that should be used when the building gets damaged.
@export var DamageVariants : Array[DamageVariant]

## Hitpoint regeneration rate per second.
@export var RegenRate : float

## Hitpoint regeneration rate per second when idle or garrisoned.
@export var IdleRegenRate : float

## Behaviour when the unit dies
@export var DeathType : EDeathType

## Entity template to spawn when this entity dies. Note: this is different than the corpse, which retains the original entity' appearance
@export var SpawnEntityOnDeath : String

## Indicates that the entity can not be healed by healer units
@export var Unhealable : bool

var maxHitpoints : float
var hitpoints : float
var regenRate : float
var idleRegenRate : float

func _ready():
	# Cache this value so it allows techs to maintain previous health level
	self.maxHitpoints = self.Max;
	# Default to <Initial>, but use <Max> if it's undefined or zero
	# (Allowing 0 initial HP would break our death detection code)
	self.hitpoints = self.Initial if self.Initial != -1 else self.maxHitpoints;
	self.regenRate = ValueModification.apply_to_entity("Health/RegenRate", self.RegenRate, self.entity);
	self.idleRegenRate = ValueModification.apply_to_entity("Health/IdleRegenRate", self.IdleRegenRate, self.entity);
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
	var cmpFogging = PyrogenesisEngine.QueryInterface(self.entity, ICmpFogging.IID_Fogging);
	if (cmpFogging):
		cmpFogging.Activate();

	var old = self.hitpoints;
	self.hitpoints = max(1, min(self.get_max_hitpoints(), value));

	var cmpRangeManager = PyrogenesisEngine.QueryInterface(PyrogenesisEngine.SYSTEM_ENTITY,ICmpRangeManager.IID_RangeManager);
	if (cmpRangeManager):
		cmpRangeManager.SetEntityFlag(self.entity, "injured", self.is_injured());

	self.register_health_changed(old);

func check_regen_timer():
	pass

func update_actor():
	pass
	
func register_health_changed(old : float):
	pass
