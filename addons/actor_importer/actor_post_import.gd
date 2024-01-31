@tool # Needed so it runs in editor.
extends EditorScenePostImport

# Called right after the scene is imported and gets the root node.
func _post_import(scene: Node):
	print(get_source_file())
	
	return scene # Remember to return the imported scene
