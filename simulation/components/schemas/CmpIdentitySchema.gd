# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends Resource
class_name CmpIdentitySchema

enum Rank {
	None,
	Basic,
	Advanced,
	Elite
}

@export var civ : String = "Civ Key"
@export var generic_name : String = "Generic Name"
@export var specific_name : String = "Specific Name"
@export var icon : Texture2D
@export var rank : Rank = Rank.None
@export var history : String = ""
@export var phenotypes : PackedStringArray
@export var selection_group_name : String = ""
@export var tooltip : String = ""
@export var lang : String = ""
@export var classes : PackedStringArray
@export var visible_classes : PackedStringArray
@export var requirements = RequirementsHelper.build_schema()
@export var is_undeletable : bool = false
@export var is_controllable : bool = false
