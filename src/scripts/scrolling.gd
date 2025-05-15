extends Node2D


func _init() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event: InputEvent) -> void:
	if not event.is_action_pressed('pause'):
		return
		
	get_tree().paused = not get_tree().paused
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if get_tree().paused else Input.MOUSE_MODE_CAPTURED

func closed_door() -> void:
	print("closed door")

func open_curtains() -> void:
	print("open curtains")
