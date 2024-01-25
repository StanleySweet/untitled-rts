extends StaticBody3D
class_name Interactable

signal interacted(body)

@export var prompt_message : String  = "Interact"
@export var prompt_action : String = "interact"
@export var enabled : bool = true

func get_prompt():
	if not self.enabled:
		return "Button is disabled."
	
	var object : Identity = get_node("../../Identity")
	print(object.generic_name)
	print(IIdentity.IID_Identity)
	print(IUnitAI.IID_UnitAI)
	
	var key_name = ""
	for action : InputEvent in InputMap.action_get_events(prompt_action):
		if action is InputEventKey:
			key_name = OS.get_keycode_string(action.physical_keycode)
	return prompt_message + "\n[" + key_name + "]"

func interact(body):
	if self.enabled:
		emit_signal("interacted", body)
