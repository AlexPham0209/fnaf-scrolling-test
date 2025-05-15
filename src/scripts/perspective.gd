extends ColorRect

@export var maxLongitude: float = 360
@export var maxLatitude: float = 180
@export var center: Vector2 = Vector2(0.5, 0.5)
@export var fov: Vector2 = Vector2(0.7, 0.75)
@export var wrap: bool = false
@export var captured = false

func _ready() -> void:
	self.visible = true

	if captured:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	maxLongitude = maxLongitude * PI/360
	maxLatitude = maxLatitude * PI/360
	
	self.material.set_shader_parameter('centerPoint', center)
	self.material.set_shader_parameter('maxLongitude', maxLongitude)
	self.material.set_shader_parameter('maxLatitude', maxLatitude)
	self.material.set_shader_parameter('wrap', wrap)
	

func _physics_process(delta: float) -> void:	
	if not captured:
		var move = get_global_mouse_position() / self.size
		center.x = fposmod(move.x, 1.0)
		center.y = clamp(move.y, 0., 1)
	
	self.material.set_shader_parameter('centerPoint', center)
	
	if Input.is_action_just_pressed("ui_accept"):
		self.visible = not self.visible

func _input(event):
	if not captured:
		return
		
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		center.x = fposmod(center.x + event.relative.x * (0.001 / 2), 1.0)
		center.y = clamp(center.y + event.relative.y * (0.002 / 2), 0, 1)
