# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends Resource

enum EShape {
	Circular,
	Linear
}

## Shape of the splash damage, can be circular or linear
@export var ShapeType : EShape
## Size of the area affected by the splash
@export_range(0, 10000) var SplashRange : float
## Whether the splash damage can hurt non enemy unit
@export var FriendlyFire : bool
@export var Effect : AttackEffect
