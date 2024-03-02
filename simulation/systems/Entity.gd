class_name Entity

## Invalid entity ID. Used as an error return value by some functions.
## No valid entity will have this ID.
static var INVALID_ENTITY = 0;
## Entity ID for singleton 'system' components.
## Use with QueryInterface to get the component instance.
## (This allows those systems to make convenient use of the common infrastructure
## for message-passing, scripting, serialisation, etc.)
static var SYSTEM_ENTITY = 1;

class EntityHandle:
	
	var id : int
	
	func get_id() -> int:
		return self.id
