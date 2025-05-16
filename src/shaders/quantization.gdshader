shader_type canvas_item;
uniform int numColors = 5;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

vec3 quantize(vec3 color) {
	return floor(color * float(numColors)) / float(numColors);
}

void fragment() {
	// Called for every pixel the material is visible on.\
	
	vec3 color = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0f).rgb;
	COLOR.rgb = quantize(color);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
