# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends ICmpWallset
class_name CmpWallSet

## Maximum fraction that wall segments are allowed
## to overlap towers, where 0 signifies no overlap
## and 1 full overlap
@export_range(0.0, 1.0) var MinTowerOverlap: float
## Minimum fraction that wall segments are required
## to overlap towers, where 0 signifies no overlap
## and 1 full overlap
@export_range(0.0, 1.0) var MaxTowerOverlap: float
@export var Templates : WallSetTemplates
