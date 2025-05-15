extends Node2D

@onready var interactables = $Interactables
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	for interactable in interactables.get_children().filter(func(node): return node is Interactable):
		interactable.pressed.connect(pressed)
	
func _input(event: InputEvent) -> void:
	if not event.is_action_pressed('pause'):
		return
		
	get_tree().paused = not get_tree().paused
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if get_tree().paused else Input.MOUSE_MODE_CAPTURED

func pressed() -> void:
	print("pressed")
