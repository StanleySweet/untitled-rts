# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends Resource
class_name WallSetTemplates
## Template name of the tower piece
@export var Tower : String
## Template name of the gate piece
@export var Gate : String
## Template name of the long wall segment
@export var WallLong : String
## Template name of the medium-size wall segment
@export var WallMedium : String
## Template name of the short wall segment
@export var WallShort : String
## Whitespace-separated list of template names of curving wall segments.
@export var WallCurves : String
@export var WallEnd : String
@export var Fort : String
