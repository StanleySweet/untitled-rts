# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends Resource
class_name DamageVariant
## Name of the variant to select when health drops under the defined ratio
@export var variant_name : String
@export_range(0.0, 1.0) var ratio : float

func _init(variant_name: String = "", ratio: float = 0.0):
	self.variant_name = variant_name
	self.ratio = ratio
