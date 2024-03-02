# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

class_name PositionHelper

static func get_spawn_position(entity:int, target: int, forced: bool) -> Vector2:
	return Vector2(0.0, 0.0)

static func distance_between_entities(ent1 : int, ent2 : int) -> int:
	return 0