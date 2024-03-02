# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends IComponent
class_name ICmpUnitAI
static var IID = PyrogenesisEngine.register_interface(ICmpUnitAI)

func replace_order(order, new_order):
    push_error("Not implemented")

func garrison(holderId, _b, _c):
    push_error("Not implemented")

func back_to_work():
    push_error("Not implemented")

func has_work_orders() -> bool:
    push_error("Not implemented")
    return false