shader_type canvas_item;
uniform vec2 centerPoint;
uniform vec2 FOV;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float maxLongitude;
uniform float maxLatitude;

uniform bool wrap;

// Turns equirectangular image into rectilinear/gnomonic image.
// https://www.shadertoy.com/view/ls2cz3
// http://mathworld.wolfram.com/GnomonicProjection.html
// https://blog.nitishmutha.com/equirectangular/360degree/2017/06/12/How-to-project-Equirectangular-image-to-rectilinear-view.html
vec2 toGnomonic(vec2 uv, vec2 center, vec2 fovScale) {
	//Converting it from a range of [0, 1] to [-PI, PI/2].  Converting it to radian form.
	vec2 cp = (center * 2.0f - 1.0f) * vec2(maxLongitude, maxLatitude);
	vec2 sphCoords = (uv * 2.0f - 1.0f) * fovScale * vec2(maxLongitude, maxLatitude);
	float x = sphCoords.x;
	float y = sphCoords.y;
	
	//Gets the length of the vector and find its angle of elevation.
	float p = sqrt(x * x + y * y);
	float c = atan(p);

	//Convert to spherical coordinates (azimuth, elevation).  Thus, mapping the x and y in the texture to the sphere.
	float lon = cp.x + atan(x * sin(c), p * cos(cp.y) * cos(c) - y * sin(cp.y) * sin(c));
	float lat = asin(cos(c) * sin(cp.y) + (y * sin(c) * cos(cp.y))/p);
	
	//Converting the spherical coordinates to ranges [0, 1].
	vec2 output = vec2((lon / maxLongitude + 1.0f) * 0.5, (lat / maxLatitude + 1.0f) * 0.5);
	return output;
}

void fragment() {
	vec2 sphericalCoords = toGnomonic(SCREEN_UV, centerPoint, FOV);
	COLOR = textureLod(SCREEN_TEXTURE, wrap ? fract(sphericalCoords) : sphericalCoords, 0.00f);
}