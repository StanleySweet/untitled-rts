extends StaticBody3D
class_name Interactable

signal interacted(body)

@export var prompt_message : String  = "Interact"
@export var prompt_action : String = "interact"
@export var enabled : bool = true

func get_identity() -> ICmpIdentity:
	if not self.enabled:
		return null

	return get_node("../../CmpIdentity")

func interact(body):
	if self.enabled:
		emit_signal("interacted", body)
