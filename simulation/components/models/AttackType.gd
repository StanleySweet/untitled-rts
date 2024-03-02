# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends Resource
class_name AttackType

enum EAttackType {
	Melee,
	Ranged,
	Capture,
	Slaughter
}

@export var Type : EAttackType
## Name of the attack, to be displayed in the GUI. Optionally includes a translate context attribute 
@export var AttackName : String
@export var Effect : AttackEffect
## Maximum attack range (in metres)
@export_range(0, 10000) var MaxRange : float
## Minimum attack range (in metres). Defaults to 0.
@export_range(0, 10000) var MinRange : float
@export var Origin : Transform3D
@export var Overlay : RangeOverlay
@export_range(0, 10000) var PrepareTime : int
## Delay of applying the effects, in milliseconds after the attack has landed. Defaults to 0.
@export_range(0, 10000) var EffectDelay : float
## Space delimited list of classes preferred for attacking. If an entity has any of theses classes, it is preferred. The classes are in descending order of preference
@export var PreferredClasses : PackedStringArray
## Space delimited list of classes that cannot be attacked by this entity. If target entity has any of these classes, it cannot be attacked
@export var RestrictedClasses : PackedStringArray
@export var Projectile : AttackProjectile

