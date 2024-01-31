@tool
extends Resource
class_name PyrogenesisResources

func keys() -> PackedStringArray:
	return toto.keys()

var toto : Dictionary

func _get(property: StringName) -> Variant:
	if toto.has(property):
		return toto[property];
	return null

func _set(property: StringName, value : Variant) -> bool:
	toto[property] = value;
	return true

func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = []
	var dir = DirAccess.open("res://simulation/data/resources")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				properties.push_back({
					"name": file_name.split('.')[0],
					"type": TYPE_FLOAT,
					"usage": PropertyUsageFlags.PROPERTY_USAGE_DEFAULT,
					"hint": PropertyHint.PROPERTY_HINT_RANGE
				})
			file_name = dir.get_next()
	return properties
