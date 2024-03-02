# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends IComponent
class_name ICmpAttackDetection
static var IID = PyrogenesisEngine.register_interface(ICmpAttackDetection)
signal attack_detected
signal minimap_ping
