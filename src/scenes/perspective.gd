extends ColorRect

@export var fov: Vector2 = Vector2(0.7, 0.75)
@export var cp: Vector2 = Vector2(0.5, 0.5)

func _ready() -> void:
	self.visible = true
	self.material.set_shader_parameter('centerPoint', cp)
	self.material.set_shader_parameter('FOV', fov)
	

func _physics_process(delta: float) -> void:
	var center = Vector2(4096 / 2, 2048 / 2)
	var move = get_global_mouse_position() / Vector2(4096, 2048)
	
	cp.x = move.x
	cp.y = move.y
	self.material.set_shader_parameter('centerPoint', cp)
	
	if Input.is_action_just_pressed("ui_accept"):
		self.visible = not self.visible
	
