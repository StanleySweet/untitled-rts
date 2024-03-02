# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends IComponent
class_name ICmpObstruction
static var IID = PyrogenesisEngine.register_interface(ICmpObstruction)

func set_active(enabled : bool) -> void:
	push_error("Not implemented")
