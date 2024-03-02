# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends IComponent
class_name ICmpGarrisonable
static var IID = PyrogenesisEngine.register_interface(ICmpGarrisonable)

func total_size() -> int:
	push_error("Not implemented")
	return 0
