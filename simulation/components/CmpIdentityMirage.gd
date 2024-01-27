# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends CmpIdentity
class_name CmpdentityMirage

# Called when the node enters the scene tree for the first time.
func _ready():
	# Mirages don't get identity classes via the template-filter, so that code can query
	# identity components via Engine.QueryInterface without having to explicitly check for mirages.
	# This is cloned as otherwise we get a reference to Identity's property,
	# and that array is deleted when serializing (as it's not seralized), which ends in OOS.
	pass;
