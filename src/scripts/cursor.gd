extends Area2D

@export var perspective: ColorRect
const PI_2 = PI * 0.5;

func _physics_process(delta: float) -> void:
	# Convert positions relative to perspective shader rect and normalize between (0, 1)
	var pos: Vector2 = get_global_mouse_position() - self.perspective.global_position
	pos /= Vector2(4096, 2048)
	
	
	var cp = (self.perspective.cp * 2.0 - Vector2.ONE) * Vector2(PI, PI_2)
	pos = (pos * 2.0 - Vector2.ONE) * self.perspective.fov * Vector2(PI, PI_2)
		
	var x = pos.x
	var y = pos.y
	
	var p = sqrt(x * x + y * y) + 1e-7
	var c = atan(p)
	
	var lat = asin(cos(c) * sin(cp.y) + ((y * sin(c) * cos(cp.y)) / p))
	var lon = cp.x + atan2((x * sin(c)), ((p * cos(cp.y) * cos(c)) - (y * sin(cp.y) * sin(c))))
	
	pos = Vector2((lon / PI + 1.0) * 0.5, (lat / PI_2 + 1.0) * 0.5)
	
	if perspective.apply_modifiers:
		var conversion = Vector2(180.0/self.perspective.zoom.x, 90.0/self.perspective.zoom.y);
		
		pos.x *= conversion.x;
		pos.y *= conversion.y;
		
		pos.x -= (conversion.x/2.0)-0.5;
		pos.y -= (conversion.y/2.0)-0.5;
	
	pos = Vector2(fposmod(pos.x, 1.0), fposmod(pos.y, 1.0))
	pos *= Vector2(4096, 2048)
	pos += self.perspective.global_position
	self.global_position = pos
	

	
