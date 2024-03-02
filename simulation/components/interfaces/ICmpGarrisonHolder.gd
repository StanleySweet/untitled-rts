# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends IComponent
class_name ICmpGarrisonHolder
static var IID = PyrogenesisEngine.register_interface(ICmpGarrisonHolder)

func is_allowed_to_garrison(_ent : int) -> bool:
	push_error("Not implemented")
	return false
