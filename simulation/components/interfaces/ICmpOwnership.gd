# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends IComponent
class_name ICmpOwnership
static var IID = PyrogenesisEngine.register_interface(ICmpOwnership)

func get_owner_id() -> int:
	push_error("Not implemented")
	return PlayerHelper.INVALID_PLAYER
