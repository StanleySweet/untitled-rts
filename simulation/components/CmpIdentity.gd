# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends ICmpIdentity
class_name CmpIdentity

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

var phenotype : String = ""
var rank_string : String = ""

func _ready() -> void:
	if self.phenotypes.size() > 0:
		self.phenotype = self.phenotypes[randi_range(0,self.phenotypes.size()-1)]
	else:
		self.phenotype = "default"

	self.rank_string = str(self.rank)
	self.lang = self.lang if self.lang != "" else "greek"

func get_rank() -> String:
	return self.rank_string

func get_rank_tech_name() -> String:
	return "unit_" + self.rank_string.to_lower() if self.rank != Rank.None else ""

func has_class(identity_class : String) -> bool:
	return self.classes.has(identity_class)

func get_mirage() -> CmpdentityMirage:
	var mirage : CmpdentityMirage = CmpdentityMirage.new()
	mirage.classes = self.classes.duplicate()
	return mirage
