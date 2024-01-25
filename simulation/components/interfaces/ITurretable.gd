# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends Node
class_name ITurretable
static var IID_Turretable = PyrogenesisEngine.register_interface("Turretable")
static var MT_TurretedStateChanged = PyrogenesisEngine.register_interface("TurretedStateChanged")
