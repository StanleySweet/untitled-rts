# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends IComponent
class_name ICmpFoundation
static var IID = PyrogenesisEngine.register_interface(ICmpFoundation)

func add_builder(_ent: int) -> void:
    push_error("Not implemented")

func remove_builder(_ent: int) -> void:
    push_error("Not implemented")

func build(_ent: int, _rate : int) -> void:
    push_error("Not implemented")