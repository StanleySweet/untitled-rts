# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends Resource
class_name CmpAlertRaiserSchema

@export var List : PackedStringArray
@export var RaiseAlertRange : int 
@export var EndOfAlertRange : int
@export var SearchRange : int
