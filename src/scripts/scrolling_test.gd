extends Node2D

@onready var perspective = $Perspective
var center_point: Vector2 = Vector2(0.5, 0.5)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	center_point.x -= 0.05 * delta
	perspective.material.set_shader_parameter('centerPoint', center_point)


func _on_button_pressed() -> void:
	print("yayyy")
