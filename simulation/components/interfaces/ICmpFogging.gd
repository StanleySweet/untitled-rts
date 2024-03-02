# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends IComponent
class_name ICmpFogging
static var IID = PyrogenesisEngine.register_interface(ICmpFogging)

func activate():
	push_error("Not implemented")