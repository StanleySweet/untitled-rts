# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends IComponent
class_name ICmpTurretable
static var IID = PyrogenesisEngine.register_interface(ICmpTurretable)
signal turreted_state_changed
