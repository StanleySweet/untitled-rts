@tool
extends EditorPlugin

const post_import_script: GDScript = preload("./actor_post_import.gd")
const IMPORT_FOLDER : String = "res://import/"

class GDLog:
	static func info(message: String):
		print(format_time() + "|INFO|" + message)
	static func error(message: String):
		push_error(format_time() + "|INFO|" + message)
	static func warn(message: String):
		push_warning(format_time() + "|INFO|" + message)
		
	static func format_time() -> String:
		var timestamp: Dictionary = Time.get_datetime_dict_from_system(false) 
		return str(timestamp.hour) + ":" + str(timestamp.minute) + ":" + str(timestamp.second)
		
class XmlActor:
	func _init(stream : FileAccess):
		self.array = []
		
	func append(value):
		self.array.append(value)

func show_importer():
	pass

class PyrogenesisVariant:
	var frequency : int
	var name: String
	var file: String
	var textures : Array
	var props : Array
	var animations : Array
	var mesh: String
	
	func _init(xml_parser: XMLParser):
		if xml_parser.has_attribute("name"):
			self.name = xml_parser.get_named_attribute_value("name")
		else:
			self.name = ""
		if xml_parser.has_attribute("frequency"):
			self.frequency = int(xml_parser.get_named_attribute_value("frequency"))
		else:
			self.frequency = 0
		if xml_parser.has_attribute("file"):
			self.file = xml_parser.get_named_attribute_value("file")
			
class PyrogenesisTexture:
	var name: String
	var file: String
	func _init(xml_parser: XMLParser):
		self.file = xml_parser.get_named_attribute_value("file")
		self.name = xml_parser.get_named_attribute_value("name")
	
class PyrogenesisProp:
	var actor: String
	var attachpoint: String
	
	func _init(xml_parser: XMLParser):
		self.actor = xml_parser.get_named_attribute_value("actor")
		self.attachpoint = xml_parser.get_named_attribute_value("attachpoint")
		
class PyrogenesisAnimation:
	var name: String
	var id: String
	var frequency: int
	var file: String
	var speed: int
	var event: float
	var load: float
	var sound: float
	
	func _init(xml_parser: XMLParser):
		if xml_parser.has_attribute("name"):
			self.name = xml_parser.get_named_attribute_value("name")
		else:
			self.name = ""
		if xml_parser.has_attribute("frequency"):
			self.frequency = int(xml_parser.get_named_attribute_value("frequency"))
		else:
			self.frequency = 0
		if xml_parser.has_attribute("id"):
			self.id = xml_parser.get_named_attribute_value("id")
		if xml_parser.has_attribute("file"):
			self.id = xml_parser.get_named_attribute_value("file")
		if xml_parser.has_attribute("speed"):
			self.speed = int(xml_parser.get_named_attribute_value("speed"))
		if xml_parser.has_attribute("event"):
			self.event = float(xml_parser.get_named_attribute_value("event"))
		if xml_parser.has_attribute("load"):
			self.load = float(xml_parser.get_named_attribute_value("load"))
		if xml_parser.has_attribute("sound"):
			self.sound = float(xml_parser.get_named_attribute_value("sound"))
class PyrogenesisGroup:
	var variants : Array

class PyrogenesisActor:
	var version: int
	var file_name: String
	var casts_shadows: bool
	var floats_on_water: bool
	var material: String
	var groups: Array


func parse_variant_file(file_path):
	var xml_parser = XMLParser.new()
	var result = xml_parser.open(file_path)
	var current_variant : Variant
	var current_name : String = ""
	while result == OK:
		result = xml_parser.read()
		var node_type = xml_parser.get_node_type()
		if xml_parser.get_node_name() != "":
			current_name = xml_parser.get_node_name()
		if node_type == XMLParser.NODE_ELEMENT:
			if current_name == "animations":
				current_variant.animations = []
			if current_name == "animation":
				current_variant.animation.append(PyrogenesisProp.new(xml_parser))
			if current_name == "variant":
				current_variant = PyrogenesisVariant.new(xml_parser)
			if current_name == "props":
				current_variant.props = []
			if current_name == "prop":
				current_variant.props.append(PyrogenesisProp.new(xml_parser))
			if current_name == "textures":
				current_variant.textures = []
			if current_name == "texture":
				current_variant.textures.append(PyrogenesisTexture.new(xml_parser))
		elif node_type == XMLParser.NODE_ELEMENT_END:
			pass
		elif node_type == XMLParser.NODE_TEXT:
			if current_name == "mesh":
				current_variant.mesh = xml_parser.get_node_data()
				
	var parent_variant = null
	if current_variant.file != null && current_variant.file != "":
		parent_variant = parse_variant_file(get_variant_directory(file_path) + current_variant.file)


func _on_file_selected(file_path):
	# Use the File class to open and read the XML file.
	if FileAccess.file_exists(file_path):
		var xml_parser = XMLParser.new()
		var result = xml_parser.open(file_path)
		var actor = PyrogenesisActor.new()
		var current_group = null
		var current_variant = null
		var current_name : String = ""
		while result == OK:
			result = xml_parser.read()
			var node_type = xml_parser.get_node_type()
			if xml_parser.get_node_name() != "":
				current_name = xml_parser.get_node_name()
			if node_type == XMLParser.NODE_ELEMENT:
				if current_name == "qualitylevels":
					GDLog.info("Quality levels are not supported yet!")
				if current_name == "actor":
					actor.version = int(xml_parser.get_named_attribute_value("version"))
					var path_bits = file_path.split("/")
					actor.file_name = path_bits[path_bits.size() -1]
				if current_name == "group":
					current_group = PyrogenesisGroup.new()
				if current_name == "props":
					current_variant.props = []
				if current_name == "prop":
					current_variant.props.append(PyrogenesisProp.new(xml_parser))
				if current_name == "animations":
					current_variant.animations = []
				if current_name == "animation":
					current_variant.animation.append(PyrogenesisProp.new(xml_parser))
				if current_name == "textures":
					current_variant.textures = []
				if current_name == "texture":
					current_variant.textures.append(PyrogenesisTexture.new(xml_parser))
				if current_name == "variant":
					current_variant = PyrogenesisVariant.new(xml_parser)
			elif node_type == XMLParser.NODE_ELEMENT_END:
				if current_name == "group":
					if current_group != null:
						actor.groups.append(current_group)
						current_group = null
				if current_name == "variant":
					if current_group != null && current_variant != null:
						current_group.variants.append(current_variant)
						current_variant = null
				current_name = ""
			elif node_type == XMLParser.NODE_TEXT:
				if current_name == "material":
					actor.material = xml_parser.get_node_data()
				if current_name == "castshadow":
					actor.casts_shadows = true
				if current_name == "mesh":
					current_variant.mesh = xml_parser.get_node_data()
		process_actor(actor, file_path)
	else:
		GDLog.error("Failed to open the file:" + file_path)
		
func get_variant_directory(file_path: String):
	return file_path.split("actors")[0] + "actors/variants/"
	
func get_meshes_directory(file_path: String):
	return file_path.split("actors")[0] + "meshes/"

func get_textures_directory(file_path: String):
	return file_path.split("actors")[0] + "textures/skins/"

func import_textures(variant : PyrogenesisVariant, file_path : String):
	for texture in variant.textures:
		import_texture(variant, texture, file_path)

func import_texture(variant: PyrogenesisVariant, texture: PyrogenesisTexture, file_path: String):
	var texture_path : String = get_textures_directory(file_path) + texture.file;
	var output_texture_path: String = IMPORT_FOLDER + "textures/skins/" + texture.file;
	var dres2 = DirAccess.open("res://")
	var error = dres2.make_dir_recursive(output_texture_path.get_base_dir())
	if error == OK:
		error = dres2.copy(texture_path, output_texture_path)
		var cfile = ConfigFile.new()
		cfile.set_value("remap", "importer", "texture")
		cfile.set_value("remap", "type", "CompressedTexture2D")
		cfile.set_value("params", "mipmaps/generate", true)
		cfile.set_value("params", "compress/mode", 2)
		cfile.set_value("params", "import_script/path", post_import_script.resource_path)
		var cfile_error = cfile.save(output_texture_path + ".import")
		if error == OK and cfile_error == OK:
			GDLog.info("Saved '" + output_texture_path + "' successfully.")
		else:
			GDLog.error("Error saving texture: " + str(error))
	else:
		GDLog.error("Error saving texture: " + str(error))

func import_mesh(variant, file_path):
	var collada_path: String = get_meshes_directory(file_path) + variant.mesh;
	var output_collada_path: String = IMPORT_FOLDER + "meshes/" + variant.mesh;
	var dres2 = DirAccess.open("res://")
	var error = dres2.make_dir_recursive(output_collada_path.get_base_dir())
	if error == OK:
		error = dres2.copy(collada_path, output_collada_path)
		var cfile = ConfigFile.new()
		cfile.set_value("remap", "importer", "scene")
		cfile.set_value("remap", "importer_version", 1)
		cfile.set_value("remap", "type", "PackedScene")
		cfile.set_value("params", "animation/fps", 24)
		cfile.set_value("params", "meshes/create_shadow_meshes", true)
		cfile.set_value("params", "nodes/apply_root_scale", false)
		cfile.set_value("params", "nodes/root_name", "Root Scene")
		cfile.set_value("params", "gltf/embedded_image_handling", 0)
		cfile.set_value("params", "import_script/path", post_import_script.resource_path)
		var subresources: Dictionary = cfile.get_value("params", "_subresources", {})
		subresources["nodes"] = {}
		subresources["nodes"]["PATH:AnimationPlayer"] = {}
		subresources["nodes"]["PATH:AnimationPlayer"]["import_tracks/scale"]  = 2
		cfile.set_value("params", "_subresources", subresources)
		var cfile_error = cfile.save(output_collada_path + ".import")
		if error == OK and cfile_error == OK:
			GDLog.info("Saved '" + output_collada_path + "' successfully.")
		else:
			GDLog.error("Error saving mesh: " + str(error))
	else:
		GDLog.error("Error saving mesh: " + str(error))

func process_actor(actor, file_path):
	var variant_directory : String = get_variant_directory(file_path)
	for group in actor.groups:
		for variant in group.variants:
			if variant.file != null and variant.file != "":
				parse_variant_file(variant_directory + variant.file)

			if variant.textures != null and variant.textures.size() > 0:
				import_textures(variant, file_path)

			if variant.mesh != null and variant.mesh != "":
				import_mesh(variant, file_path)

func show_modal():
	var file_dialog : EditorFileDialog = EditorFileDialog.new()
	file_dialog.set_title("Import Pyrogenesis Actor")
	file_dialog.set_access(EditorFileDialog.ACCESS_FILESYSTEM)
	file_dialog.set_file_mode(EditorFileDialog.FILE_MODE_OPEN_FILE)
	file_dialog.add_filter("*.xml")
	file_dialog.file_selected.connect(_on_file_selected)
	file_dialog.popup()
	get_tree().root.add_child(file_dialog)

func _enter_tree():
	self.add_tool_menu_item("Import Pyrogenesis Actor...", self.show_modal)

func _exit_tree():
	self.remove_tool_menu_item("Import Pyrogenesis Actor...")
	

	
