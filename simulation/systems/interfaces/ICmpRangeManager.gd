# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends IComponent
class_name ICmpRangeManager
static var IID = PyrogenesisEngine.register_interface(ICmpRangeManager)

func execute_query(ent : int, minRange : int, maxRange, ownerIds : PackedInt32Array, iid : int, boolean : bool) -> PackedInt32Array:
    return []