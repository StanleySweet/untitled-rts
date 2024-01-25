# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends Node

class_name PyrogenesisEngine

static var component_count = 1
static var message_count = 1

static var IID_UnitAI = 2;
static var IID_Position = 2;
static var IID_ObstructionManager = 3;
static var IID_TurretHolder_Name = "TurretHolder";
static var INVALID_ENTITY = -1

static func QueryInterface(entity_id, iid):
	pass

static func register_interface(interface_name: String) -> int:
	return ++component_count

static func register_message_type(message_name : String) -> int:
	return +message_count

static func post_message(sender: int, message_type: int, message) -> void:
	pass;
