shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec2 dr = vec2(1.0, 0.0);
uniform vec2 dg = vec2(0.0, 0.0);
uniform vec2 db = vec2(-1.0, 0.0);
uniform float width: hint_range(0.0, 1.0, 0.1) = 0.5;
uniform float height: hint_range(0.0, 1.0, 0.1) = 0.7;
uniform float curvature: hint_range(0.0, 10.0, 0.01) = 2.0;
uniform sampler2D noise_texture: filter_linear_mipmap, repeat_enable;

void fragment() {
	vec2 uv = FRAGCOORD.xy / (1.0 / SCREEN_PIXEL_SIZE).xy;
	uv -= vec2(0.5, 0.5);
	uv = uv * 1.2 * (1.0 / 1.2 + curvature * uv.x * uv.x * uv.y * uv.y);
	uv += vec2(0.5, 0.5);
	
	float sWidth = 2.0 / width;
	float sHeight = 2.0 / height;
	float dist = distance(vec2(uv.x * sWidth, uv.y * sHeight), vec2(0.5 * sWidth, 0.5 * sHeight));
	
	float r = texture(SCREEN_TEXTURE, uv + vec2(SCREEN_PIXEL_SIZE * dr), 0.0).r;
	float g = texture(SCREEN_TEXTURE, uv + vec2(SCREEN_PIXEL_SIZE * dg), 0.0).g;
	float b = texture(SCREEN_TEXTURE, uv + vec2(SCREEN_PIXEL_SIZE * db), 0.0).b;
	
	float noise = -0.1 + texture(noise_texture, vec2(0.0, 0.005 * TIME)).x * 0.2;
	r += noise;
	g += noise;
	b += noise;
	
	COLOR = vec4(r, g, b, 1.0);
}
