extends Area2D

@export var perspective: ColorRect
const PI_2 = PI * 0.5;

func _physics_process(delta: float) -> void:
	# Convert positions relative to perspective shader rect and normalize between (0, 1)
	var pos: Vector2 = get_global_mouse_position() - self.perspective.global_position
	pos /= perspective.size
	
	var cp = (self.perspective.center * 2.0 - Vector2.ONE) * Vector2(perspective.maxLongitude, perspective.maxLatitude)
	pos = (pos * 2.0 - Vector2.ONE) * self.perspective.fov * Vector2(perspective.maxLongitude, perspective.maxLatitude)
		
	var x = pos.x
	var y = pos.y
	
	var p = sqrt(x * x + y * y) + 1e-7
	var c = atan(p)
	
	var lat = asin(cos(c) * sin(cp.y) + ((y * sin(c) * cos(cp.y)) / p))
	var lon = cp.x + atan2(x * sin(c), p * cos(cp.y) * cos(c) - y * sin(cp.y) * sin(c))
	
	pos = Vector2((lon / perspective.maxLongitude + 1.0) * 0.5, (lat / perspective.maxLatitude + 1.0) * 0.5)
	
	pos *= perspective.size
	pos += self.perspective.global_position
	self.global_position = pos
	

	
