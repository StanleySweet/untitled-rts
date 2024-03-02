# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends Resource
class_name CmpFootprintSchema


enum EShape {
	## Size of the footprint along the front/back direction (in metres)
	Circle,
	## Set the footprint to a square of the given size
	Square
}


@export var shapetype : EShape

## Size of the footprint along the left/right direction (in metres) / Radius of the footprint (in metres)
@export var WidthRadius : float = 1.0;

## Size of the footprint along the front/back direction (in metres) / Radius of the footprint (in metres)
@export var DepthRadius : float = 1.0;

## Vertical extent of the footprint (in metres)
@export var Height : float = 4.0;

## Farthest distance units can spawn away from the edge of this entity
@export var MaxSpawnDistance : float = 7.0
