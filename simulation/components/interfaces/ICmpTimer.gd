# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends IComponent
class_name ICmpTimer
static var IID = PyrogenesisEngine.register_interface(ICmpTimer)

func get_time() -> float:
    return 0.0

func cancel_timer(timerId : int):
    push_error("Not implemented")

func set_interval() -> int:
    push_error("Not implemented")
    return 0
