# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends IFootprint
class_name Footprint

enum EShape {
	Circle,
	Square
}

@onready var collision_shape : CollisionShape3D = $StaticBody3D/CollisionShape3D
@export var shapetype : EShape 
@export var WidthRadius : float = 1.0;
@export var DepthRadius : float = 1.0;
@export var Height : float = 4.0;
@export var MaxSpawnDistance : float = 7.0

func _ready() -> void:
	# Offset collision to be on the ground.
	collision_shape.position.y += Height / 2.0
	
	if shapetype == EShape.Square:
		collision_shape.shape = BoxShape3D.new()
		collision_shape.shape.set_size(WidthRadius, Height, DepthRadius)
	else: # shapetype == EShape.Circle:
		collision_shape.shape = CylinderShape3D.new()
		DepthRadius = WidthRadius
		collision_shape.shape.set_radius(WidthRadius)
		collision_shape.shape.set_height(Height)
