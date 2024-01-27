# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

class_name ValueModification

static func apply_to_entity(tech_type : String, current_value, entity):
	var value = current_value;
	
	# entity can be an owned entity or a player entity.
	var cmpModifiersManager : ICmpModifiersManager = PyrogenesisEngine.QueryInterface(PyrogenesisEngine.SYSTEM_ENTITY, ICmpModifiersManager.IID_ModifiersManager);
	if cmpModifiersManager:
		value = cmpModifiersManager.ApplyModifiers(tech_type, current_value, entity);
	return value;

static func apply_to_template(tech_type : String, current_value, playerID, template):
	var value = current_value;
	var cmpModifiersManager : ICmpModifiersManager = PyrogenesisEngine.QueryInterface(PyrogenesisEngine.SYSTEM_ENTITY, ICmpModifiersManager.IID_ModifiersManager);
	if cmpModifiersManager:
		value = cmpModifiersManager.ApplyTemplateModifiers(tech_type, current_value, template, playerID);
	return value;
