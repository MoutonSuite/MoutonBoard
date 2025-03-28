shader_type canvas_item;

uniform sampler2D alpha_ramp;
uniform float ease = 1;
uniform float hue_shift = 0.33;

uniform int width:hint_range(0, 5, 1);
uniform vec4 outline_color:source_color;
uniform float flickering_speed:hint_range(0.0, 50.0, 1.);
uniform float minimal_flickering_alpha:hint_range(0.0, 0.9, 0.1);


uniform vec3 color : source_color;

uniform sampler2D behind : hint_screen_texture;

vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float avg(vec3 v) {
	float x = (v.x + v.y + v.z)/3.0;
	return x;
}

float f(float x) {
	return x < 0.5 ? 16.0 * x * x * x * x * x : 1.0 - pow(-2.0 * x + 2.0, 5.0) / 2.0;
}

vec3 trans(vec3 hsv) {
	return vec3(
		fract(hsv.x + hue_shift),
		0.9*hsv.y,
		clamp(2.0*hsv.z,0.0,1.0)
	);
}

void fragment() {
	COLOR.a = texture(alpha_ramp, vec2(pow(COLOR.r, ease))).r;
	vec3 hsv = trans(rgb2hsv(texture(behind, SCREEN_UV).rgb));
	vec3 final = hsv2rgb(hsv);
	COLOR.rgb = final;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
