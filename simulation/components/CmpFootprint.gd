# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

## Approximation of the entity's shape, for collision detection and
## may be used for outline rendering or to determine selectable bounding box.
## Shapes are flat horizontal squares or circles, extended vertically to a given height.
extends ICmpFootprint
class_name CmpFootprint

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

var collision_shape : CollisionShape3D
const interactable_script = preload("res://scripts/Interactable.gd")

func _ready() -> void:
	var static_body : StaticBody3D = StaticBody3D.new()
	self.collision_shape = CollisionShape3D.new()
	static_body.add_child(collision_shape)
	self.add_child(static_body)
	static_body.set_script(interactable_script)
	
	# Offset collision to be on the ground.
	self.collision_shape.position.y += self.Height / 2.0

	if self.shapetype == EShape.Square:
		self.collision_shape.shape = BoxShape3D.new()
		self.collision_shape.shape.set_size(self.WidthRadius, self.Height, self.DepthRadius)
	else: # self.shapetype == EShape.Circle:
		self.collision_shape.shape = CylinderShape3D.new()
		self.DepthRadius = self.WidthRadius
		self.collision_shape.shape.set_radius(self.WidthRadius)
		self.collision_shape.shape.set_height(self.Height)
