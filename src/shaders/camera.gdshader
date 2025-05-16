shader_type canvas_item;
uniform sampler2D screenTexture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float noiseScale = 100.0;
uniform float noiseAmplitude = 1.0;
uniform float start = 5.0;
uniform float stepSize = 2.0;

vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) + 0.5;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = SCREEN_UV;
	vec3 color = vec3(0.);
	float offset = noise(SCREEN_UV * noiseScale + TIME * 2.0);
	
	color.r = textureLod(screenTexture, vec2(uv.x - ((start + stepSize) - offset * noiseAmplitude) * SCREEN_PIXEL_SIZE.x, uv.y), 0.0f).r;
	color.g = textureLod(screenTexture, vec2(uv.x - ((start + stepSize * 2.) - offset * noiseAmplitude) * SCREEN_PIXEL_SIZE.x, uv.y), 0.0f).g;
	color.b = textureLod(screenTexture, vec2(uv.x - ((start + stepSize * 3.) - offset * noiseAmplitude) * SCREEN_PIXEL_SIZE.x, uv.y), 0.0f).b;
	
	COLOR.rgb = color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
