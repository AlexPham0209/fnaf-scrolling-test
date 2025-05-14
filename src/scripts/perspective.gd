extends ColorRect

@export var fov: Vector2 = Vector2(0.7, 0.75)
@export var zoom: Vector2 = Vector2(90, 30)
@export var cp: Vector2 = Vector2(0.5, 0.5)
@export var apply_modifiers: bool = false
@export var captured = false

func _ready() -> void:
	self.visible = true

	if captured:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	self.material.set_shader_parameter('centerPoint', cp)
	self.material.set_shader_parameter('zoomX', zoom.x)
	self.material.set_shader_parameter('zoomY', zoom.y)
	self.material.set_shader_parameter('FOV', fov)
	self.material.set_shader_parameter('applyModifiers', apply_modifiers)
	

func _physics_process(delta: float) -> void:
	var center = Vector2(4096 / 2, 2048 / 2)
	
	if not captured:
		var move = get_global_mouse_position() / Vector2(4096, 2048)
		cp.x = fposmod(move.x, 1.0)
		cp.y = clamp(move.y, 0.3, 0.7)
	#
	self.material.set_shader_parameter('centerPoint', cp)
	
	if Input.is_action_just_pressed("ui_accept"):
		self.visible = not self.visible

func _input(event):
	if not captured:
		return
		
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		cp.x = fposmod(cp.x + event.relative.x * 0.001, 1.0)
		cp.y = clamp(cp.y + event.relative.y * 0.002, 0.3, 0.7)
