# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

## Approximation of the entity's shape, for collision detection and
## may be used for outline rendering or to determine selectable bounding box.
## Shapes are flat horizontal squares or circles, extended vertically to a given height.
extends ICmpFootprint
class_name CmpFootprint

var collision_shape : CollisionShape3D
@export var template : CmpFootprintSchema

func _ready() -> void:
	var static_body : StaticBody3D = StaticBody3D.new()
	self.collision_shape = CollisionShape3D.new()
	static_body.add_child(collision_shape)
	self.add_child(static_body)
	static_body.set_script(preload("res://scripts/Interactable.gd"))
	
	# Offset collision to be on the ground.
	self.collision_shape.position.y += self.template.Height / 2.0

	if self.template.shapetype == CmpFootprintSchema.EShape.Square:
		self.collision_shape.shape = BoxShape3D.new()
		self.collision_shape.shape.set_size(self.template.WidthRadius, self.template.Height, self.template.DepthRadius)
	else: # self.shapetype == EShape.Circle:
		self.collision_shape.shape = CylinderShape3D.new()
		self.collision_shape.shape.set_radius(self.template.WidthRadius)
		self.collision_shape.shape.set_height(self.template.Height)
