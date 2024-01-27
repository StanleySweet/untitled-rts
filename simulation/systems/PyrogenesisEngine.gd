# SPDX-License-Identifier: GPL-2.0-or-later
# SPDX-FileCopyrightText: © 2024 Wildfire Games
# SPDX-FileCopyrightText: © 2024 Stanislas Daniel Claude Dolcini

extends Node

class_name PyrogenesisEngine

static var entity_count: int = 1
static var component_count: int = 0
static var message_count: int = 0
static var SYSTEM_ENTITY: int = 1
static var INVALID_ENTITY: int = 0

static var entities: Dictionary = {
	1 : load("res://templates/system.tscn").instantiate()
}
static var components: Dictionary
static var messages: Dictionary

static func add_entity(template : CmpTemplate):
	entity_count = entity_count + 1
	entities[entity_count] = template
	return entity_count;

static func QueryInterface(entity_id, iid):
	var template : CmpTemplate = entities[entity_id]
	return template.get_component(components[iid])

static func register_interface(interface_type) -> int:
	component_count = component_count + 1
	components[component_count] = interface_type
	return component_count

static func register_message_type(message_type) -> int:
	message_count = message_count + 1
	messages[message_count] = message_type;
	return message_count

static func post_message(sender: int, message_type: int, message) -> void:
	pass;


