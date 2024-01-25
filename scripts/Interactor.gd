extends RayCast3D

@onready var specific_name : Label = $SpecificName
@onready var generic_name : Label = $GenericName
@onready var icon : TextureRect = $Icon

var last_interactable : Interactable = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#add_exception(owner)
	specific_name.text = ""
	generic_name.text = ""
	icon.texture = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float) -> void:
	if self.last_interactable != null:
		self.last_interactable = null
		specific_name.text = ""
		generic_name.text = ""
		icon.texture = null
	
	if is_colliding():
		var detected = get_collider()
		if detected is Interactable:
			if self.last_interactable != detected:
				var identity : Identity = detected.get_identity()
				specific_name.text =identity.specific_name
				generic_name.text = identity.generic_name
				icon.texture = identity.icon
				self.last_interactable = detected
				
			if Input.is_action_just_pressed(detected.prompt_action):
				detected.interact(owner)
