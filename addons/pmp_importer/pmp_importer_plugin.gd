@tool
extends EditorImportPlugin
class_name PMPImporterPlugin

func _get_importer_name() -> String:
	return "pmp"


func _get_visible_name() -> String:
	return "Pyrogenesis PMP"


func _get_recognized_extensions() -> PackedStringArray:
	return ["pmp"]


func _get_priority() -> float:
	return 1.0

func _get_import_order() -> int:
	return 0

func _get_save_extension() -> String:
	return "scn"

func _get_resource_type() -> String:
	return "PackedScene"


enum Presets { DEFAULT }

func _get_preset_count() -> int:
	return Presets.size()


func _get_preset_name(preset) -> String:
	match preset:
		Presets.DEFAULT:
			return "Default"
		_:
			return "Unknown"


func _get_import_options(_path : String, preset_index : int) -> Array:
	match preset_index:
		Presets.DEFAULT:
			return [{
				"name" : "quad_size",
				"default_value" : 320
			}]
		_:
			return [] 


func _get_option_visibility(_option, _options, _unknown_dictionary) -> bool:
	return true


func _import(source_file : String, save_path : String, options, r_platform_variants, r_gen_files) -> Error:
	var pmp_reader: PMPReader = PMPReader.new()
	var pmp_scene : Node3D = pmp_reader.read_pmp(source_file, options)
	if (!pmp_scene):
		return pmp_scene.error
		
	var packed_scene : PackedScene = PackedScene.new()
	var err : Error = packed_scene.pack(pmp_scene)
	if (err):
		print("Failed to pack scene: ", err)
		return err

	print("Saving to %s.%s" % [save_path, _get_save_extension()])
	return ResourceSaver.save(packed_scene, "%s.%s" % [save_path, _get_save_extension()])
