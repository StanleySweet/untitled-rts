# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends ICmpModifiersManager
class_name CmpModifiersManager

func ApplyModifiers (tech_type : String, current_value, entity):
	return current_value

func ApplyTemplateModifiers (tech_type : String, current_value, playerID, template):
	return current_value
