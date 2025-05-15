class_name Perspective
extends ColorRect

@export var max_longitude: float = 360
@export var max_latitude: float = 180
@export var center: Vector2 = Vector2(0.5, 0.5)
@export var fov: Vector2 = Vector2(0.7, 0.75)

@export var x_bound: Vector2 = Vector2(0.0, 1.0)
@export var y_bound: Vector2 = Vector2(0.0, 1.0)
@export var mouse_sensitivity: Vector2 = Vector2(0.001, 0.002)

@export var wrap: bool = false

func _ready() -> void:
	self.visible = true
	
	max_longitude = max_longitude * PI/360
	max_latitude = max_latitude * PI/360
	
	self.material.set_shader_parameter('centerPoint', center)
	self.material.set_shader_parameter('maxLongitude', max_longitude)
	self.material.set_shader_parameter('maxLatitude', max_latitude)
	self.material.set_shader_parameter('wrap', wrap)
	

func _physics_process(delta: float) -> void:	
	#if not captured:
		#var move = get_global_mouse_position() / self.size
		#center.x = fposmod(move.x, 1.0)
		#center.y = clamp(move.y, 0., 1)
	
	self.material.set_shader_parameter('centerPoint', center)
	if Input.is_action_just_pressed("ui_accept"):
		self.visible = not self.visible

func _input(event):
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED or event is not InputEventMouseMotion:
		return
	
	var x = center.x + event.relative.x * mouse_sensitivity.x
	x = fposmod(x, 1.0) if wrap else x
	
	var y = center.y + event.relative.y * mouse_sensitivity.y
	center.x = clamp(x, x_bound.x, x_bound.y)
	center.y = clamp(y, y_bound.x, y_bound.y)
