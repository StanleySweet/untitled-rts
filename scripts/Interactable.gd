extends StaticBody3D
class_name Interactable

signal interacted(body)

@export var prompt_message : String  = "Interact"
@export var prompt_action : String = "interact"
@export var enabled : bool = true

func get_identity() -> Identity:
	if not self.enabled:
		return null

	return get_node("../../Identity")

func interact(body):
	if self.enabled:
		emit_signal("interacted", body)
