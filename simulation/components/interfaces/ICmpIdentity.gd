# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends IComponent
class_name ICmpIdentity
static var IID = PyrogenesisEngine.register_interface(ICmpIdentity)

func set_controllable(_controllable : bool) -> void:
	push_error("Not implemented")

func get_classes_list() -> PackedStringArray:
	push_error("Not implemented")
	return []

