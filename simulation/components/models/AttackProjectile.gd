# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends Resource
class_name AttackProjectile

## Speed of projectiles (in meters per second).
@export_range(0.001, 1000) var Speed : float
## Standard deviation of the bivariate normal distribution of hits at 100 meters. A disk at 100 meters from the attacker with this radius (2x this radius, 3x this radius) is expected to include the landing points of 39.3% (86.5%, 98.9%) of the rounds.
@export_range(0, 1000) var Spread : float
## Gravity
@export_range(0, 1000) var Gravity : float
## Whether stray missiles can hurt non enemy units.
@export var FriendlyFire : bool
## Delta from the unit position where to launch the projectile.
@export var LauchPoint : Transform3D
## Actor of the projectile animation.
@export var ActorName : String
## Actor of the projectile impact animation
@export var ImpactActorName : String
## Length of the projectile impact animation.
@export_range(0, 1000) var ImpactAnimationLifetime : float
