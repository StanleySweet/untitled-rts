extends RayCast3D

@onready var prompt : Label = $Prompt

var last_interactable : Interactable = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#add_exception(owner)
	prompt.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float) -> void:
	if self.last_interactable != null:
		self.last_interactable = null
		prompt.text = ""
	
	if is_colliding():
		var detected = get_collider()
		if detected is Interactable:
			if self.last_interactable != detected:
				prompt.text = detected.get_prompt()
				self.last_interactable = detected
				
			if Input.is_action_just_pressed(detected.prompt_action):
				detected.interact(owner)
