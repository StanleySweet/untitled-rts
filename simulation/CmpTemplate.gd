# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends Node
class_name CmpTemplate

func _ready():
	PyrogenesisEngine.add_entity(self)

func get_component(component_type : Script):
	for iteration in self.get_children():
		if typeof(iteration) == typeof(component_type):
			return iteration

	return null

