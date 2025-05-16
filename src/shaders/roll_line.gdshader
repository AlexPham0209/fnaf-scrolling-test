shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float scrollPosition = 0.5;
uniform float scrollWidth = 0.1;
uniform float frequency = 0.1;

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

float rollLine(vec2 uv) {
	float pos = mod(scrollPosition + TIME * frequency, 1.0 + scrollWidth / 2. + 1.);
	
	float offset = noise(uv * 20.0); 
	float top = smoothstep(pos - scrollWidth / 2., pos - scrollWidth / 2. + 0.01, uv.y + sin(uv.x * 30. + TIME * 10.0) * (offset * 0.01) + 0.1);
	float bottom = smoothstep(pos + scrollWidth / 2., pos + scrollWidth / 2. + 0.01, uv.y + sin(uv.x * 40. + TIME * 8.5) * (offset * 0.01) + 0.1);
	float output = top - bottom;
	
	return output;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = SCREEN_UV;
	float rollLine = rollLine(uv);
	float noise = noise(uv * 50.0);
	
	uv -= (0.005 + noise * 0.01) * rollLine;
	
	COLOR.rgb = uv.x >= 0. ? textureLod(SCREEN_TEXTURE, uv, 0.0f).rgb : vec3(0.);
}

