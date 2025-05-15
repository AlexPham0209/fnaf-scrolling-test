class_name Interactable
extends Area2D

@onready var sprite: Sprite2D = $Icon

var collided = false
signal pressed

func _on_area_entered(area: Area2D) -> void:
	sprite.modulate = Color(0,1,0) 
	collided = true

func _on_area_exited(area: Area2D) -> void:
	sprite.modulate = Color(1,1,1) 
	collided = false
	
func _input(event: InputEvent) -> void:
	if event is not InputEventMouseButton or not event.is_pressed() or not collided:
		return
	
	pressed.emit()
