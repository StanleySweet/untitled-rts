# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends IComponent
class_name ICmpTemplateManager
static var IID = PyrogenesisEngine.register_interface(ICmpTemplateManager)

static func matches_class_list(_classes : PackedStringArray, _match : PackedStringArray) -> bool:
	return false
	# for sublist in match:
	# 	# If the elements are still strings, split them by space or by '+'
	# 	if (typeof sublist === "string")
	# 		sublist = sublist.split(/[+\s]+/);
	# 	if (sublist.every(c => (c[0] === "!" && classes.indexOf(c.substr(1)) === -1) ||
	# 	                       (c[0] !== "!" && classes.indexOf(c) !== -1)))
	# 		return true;

	# return false;
