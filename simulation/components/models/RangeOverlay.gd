# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends Resource
class_name RangeOverlay

@export var LineTexture : Texture2D
@export var LineTextureMask : Texture2D
@export_range(0, 100) var LineThickness : float
