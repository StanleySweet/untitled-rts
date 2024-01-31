extends Node
class_name PMPReader

class PmpList:
	var array : Array
	func _init(stream : FileAccess):
		self.array = []
		
	func append(value):
		self.array.append(value)

class PmpHeader:
	var magic : String
	var version : int
	var data_size : int
	var map_size : int
	
	func _init(stream : FileAccess):
		self.magic = stream.get_buffer(4).get_string_from_utf8()
		self.version = stream.get_32()
		self.data_size = stream.get_32()
		self.map_size = stream.get_32()
		
class PmpHeightMap:
	extends PmpList
	func _init(stream : FileAccess, width : int, height : int):
		for i in range (0, (width * 16 + 1) * (height * 16 + 1)):
			self.append(stream.get_16())

class PmpTextures:
	extends PmpList
	func _init(stream : FileAccess):
		for i in range (0, stream.get_32()):
			var length = stream.get_32()
			self.append(stream.get_buffer(length).get_string_from_utf8())

class PmpPatch:
	var tiles : PmpTiles
	var index : int
	func _init(stream : FileAccess, index:int):
		self.index = index
		self.tiles = PmpTiles.new(stream, 16, 16, index)

class PmpPatches:
	extends PmpList
	var width : int
	var height: int
	func _init(stream, width, height):
		self.height = height
		self.width = width
		
		for i in range (0, width * height):
			self.append(PmpPatch.new(stream, i))

class PmpTile:
	var texture1 : int
	var texture2 : int
	var priority : int
	
	func _init(stream : FileAccess):
		self.texture1 = stream.get_16()
		self.texture2 = stream.get_16()
		self.priority = stream.get_32()

class PmpTiles:
	extends PmpList
	var width: int
	var height: int 
	var patchIndex:int
	func _init(stream : FileAccess, width : int, height : int, patchIndex:int):
		self.width = width
		self.height = height
		self.patchIndex = patchIndex
		for i in range(0, width * height):
			self.append(PmpTile.new(stream))

class PmpMap:
	var header : PmpHeader
	var heightMap : PmpHeightMap
	var textures : PmpTextures
	var patches : PmpPatches
	
	func _init(stream : FileAccess):
		self.header = PmpHeader.new(stream)
		self.heightMap = PmpHeightMap.new(stream, self.header.map_size, self.header.map_size)
		self.textures = PmpTextures.new(stream)
		self.patches = PmpPatches.new(stream, self.header.map_size, self.header.map_size)

func createTerrainQuad(
		x : int, 
		y : int, 
		quad_size : int, 
		grid_width : int, 
		grid_height: int,
		map : PmpMap,
		materials : Array,
		surface_tools : Array
	):
	
	var heights = map.heightMap.array
	var patch : PmpPatch = get_patch(x, y, map.patches)
	var tile : PmpTile = get_tile(x, y, patch.tiles)
	var surface_tool = surface_tools[tile.texture1] if tile.texture1 <= materials.size() else surface_tools[surface_tools.size() - 1]		

	var x0 = x * quad_size
	var x1 = (x + 1) * quad_size
	var y0 = y * quad_size
	var y1 = (y + 1) * quad_size
	
	var v00 = Vector3(x0, heights[x + y * grid_width], y0)
	var v01 = Vector3(x0, heights[x + (y + 1) * grid_width], y1)
	var v10 = Vector3(x1, heights[x + 1 + y * grid_width], y0)
	var v11 = Vector3(x1, heights[x + 1 + (y + 1) * grid_width], y1)

	
	var uv_x_offset : int = x % patch.tiles.width
	var uv_y_offset : int = y % patch.tiles.height
	var uv_increment : float = 1.0 / patch.tiles.width
	
	var uv_x = uv_x_offset * uv_increment
	var uv_y = uv_y_offset * uv_increment
	var uv_xmax = (uv_x_offset + 1) * uv_increment
	var uv_ymax = (uv_y_offset + 1) * uv_increment
	
	var uv00 = Vector2(uv_x, uv_y)
	var uv01 = Vector2(uv_x, uv_ymax)
	var uv10 = Vector2(uv_xmax, uv_y)
	var uv11 = Vector2(uv_xmax, uv_ymax)

	surface_tool.set_uv(uv00)
	surface_tool.add_vertex(v00)
	
	surface_tool.set_uv(uv10)
	surface_tool.add_vertex(v10)
	
	surface_tool.set_uv(uv01)
	surface_tool.add_vertex(v01)

	surface_tool.set_uv(uv01)
	surface_tool.add_vertex(v01)
	
	surface_tool.set_uv(uv10)
	surface_tool.add_vertex(v10)
	
	surface_tool.set_uv(uv11)
	surface_tool.add_vertex(v11)
	
func get_patch_idx(x : int, y : int, patches : PmpPatches) -> int:
	var x0: int = floor(x / patches.width)
	var y0: int = floor(y / patches.height)
	return x0 + y0 * patches.width
	
func get_patch(x : int, y : int, patches : PmpPatches) -> PmpPatch:
	return patches.array[get_patch_idx(x, y, patches)]
	
func get_tile_idx(x : int, y : int, tiles : PmpTiles) -> int:
	var x0: int = x % tiles.width
	var y0: int = y % tiles.height
	return x0 + y0 * tiles.width
	
func get_tile(x : int, y : int, tiles : PmpTiles) -> PmpTile:
	return tiles.array[get_tile_idx(x, y, tiles)]

func createTerrainMesh(map: PmpMap, quad_size : int) -> ArrayMesh:
	var heights = map.heightMap.array
	var grid_height = map.header.map_size * 16 + 1
	var grid_width = map.header.map_size * 16 + 1
		
	var materials = []
	for texture in map.textures.array:
		var mat = StandardMaterial3D.new()
		materials.append(mat)

	var surface_tools = []
	var mat_idx = 0;
	for texture in map.textures.array:
		var st = SurfaceTool.new()
		st.begin(Mesh.PRIMITIVE_TRIANGLES)
		st.set_material(materials[mat_idx])
		mat_idx += 1
		surface_tools.append(st)
		
	for y in range(grid_height - 1):
		for x in range(grid_width - 1):
			createTerrainQuad(x, y, quad_size, grid_width, grid_height, map, materials, surface_tools)

	
	var terrain_mesh = ArrayMesh.new()

	for surface_tool in surface_tools:
		surface_tool.generate_normals()
		surface_tool.generate_tangents()
		surface_tool.index()
		surface_tool.commit(terrain_mesh)
		
	var surface_tool_idx = 0
	var idx = 0
	for surface_tool in surface_tools:
		terrain_mesh.surface_set_name(surface_tool_idx, map.textures.array[idx])
		if terrain_mesh.surface_find_by_name(map.textures.array[idx]) != -1:
			surface_tool_idx = surface_tool_idx + 1
		idx = idx + 1

	return terrain_mesh


func read_pmp(source_file : String, options) -> Node3D:
	print("Attempting to import %s" % source_file)
	var stream = FileAccess.open(source_file, FileAccess.READ)
	if (!stream):
		var error = FileAccess.get_open_error()
		print("Failed to open %s: %d" % [source_file, error])
		return null

	var map = PmpMap.new(stream)
	stream.close()
	stream = null

	var terrain_mesh : ArrayMesh = createTerrainMesh(map, options["quad_size"])
	var size: float = 1.0 / (options["quad_size"] * 10.0)
	var root_node: StaticBody3D = StaticBody3D.new()
	root_node.global_scale(Vector3(size,size,size))
	root_node.name = "Terrain_Container"
	var vertices : Array = terrain_mesh.surface_get_arrays(0)
		
	var height_map_shape : HeightMapShape3D = HeightMapShape3D.new()
	var grid_height = map.header.map_size * 16 + 1
	var grid_width = map.header.map_size * 16 + 1
	height_map_shape.set_map_width(grid_height)
	height_map_shape.set_map_depth(grid_width)
	for y in range(grid_height):
		for x in range(grid_width):
			height_map_shape.map_data[x + y * grid_width] = map.heightMap.array[x + y * grid_width] / 320.0
		
		
	var collision : CollisionShape3D = CollisionShape3D.new()
	collision.name = "CollisionShape3D"
	collision.shape = height_map_shape
	var pos = 320.0 * map.header.map_size * 16 / 2.0
	collision.set_scale(Vector3(options["quad_size"], options["quad_size"], options["quad_size"]))
	collision.set_position(Vector3(pos, 0, pos))
	
	
	var mesh_instance : MeshInstance3D = MeshInstance3D.new()
	mesh_instance.name = "Terrain"
	mesh_instance.mesh = terrain_mesh
	mesh_instance.set_cast_shadows_setting(GeometryInstance3D.SHADOW_CASTING_SETTING_ON)

	root_node.add_child(mesh_instance)
	root_node.add_child(collision)
	mesh_instance.set_owner(root_node)
	collision.set_owner(root_node)
	return root_node
