extends Area2D

@export var perspective: Perspective
@export var eps: float = 1e-7

func _physics_process(delta: float) -> void:
	# Convert positions relative to perspective shader rect and normalize between (0, 1)
	var pos: Vector2 = get_global_mouse_position() - perspective.global_position
	pos /= perspective.size
	
	var angle = Vector2(perspective.max_longitude, perspective.max_latitude)
	var cp = (perspective.center * 2.0 - Vector2.ONE) * angle
	pos = (pos * 2.0 - Vector2.ONE) * perspective.fov * angle
	
	var x = pos.x
	var y = pos.y
	
	var p = sqrt(x * x + y * y) + eps
	var c = atan(p)
	
	var lat = asin(cos(c) * sin(cp.y) + ((y * sin(c) * cos(cp.y)) / p))
	var lon = cp.x + atan2(x * sin(c), p * cos(cp.y) * cos(c) - y * sin(cp.y) * sin(c))
	
	pos = Vector2((lon / perspective.max_longitude + 1.0) * 0.5, (lat / perspective.max_latitude + 1.0) * 0.5)
	
	pos *= perspective.size
	pos += perspective.global_position
	self.global_position = pos
	

	
