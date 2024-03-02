# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends ICmpIdentity
class_name CmpIdentity

@export var template : CmpIdentitySchema

var phenotype : String = ""
var rank_string : String = ""
var lang : String

func _ready() -> void:
	if self.template.phenotypes.size() > 0:
		self.phenotype = self.template.phenotypes[randi_range(0,self.template.phenotypes.size()-1)]
	else:
		self.phenotype = "default"

	self.rank_string = str(self.template.rank)
	self.lang = self.lang if self.template.lang != "" else "greek"

func get_rank() -> String:
	return self.rank_string

func get_rank_tech_name() -> String:
	return "unit_" + self.rank_string.to_lower() if self.rank != CmpIdentitySchema.Rank.None else ""

func has_class(identity_class : String) -> bool:
	return self.template.classes.has(identity_class)

func get_mirage() -> CmpdentityMirage:
	var mirage : CmpdentityMirage = CmpdentityMirage.new()
	mirage.classes = self.classes.duplicate()
	return mirage
