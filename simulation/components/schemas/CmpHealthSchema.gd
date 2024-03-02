# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends Resource
class_name CmpHealthSchema

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


