shader_type spatial;
render_mode unshaded, depth_test_disabled, cull_disabled;

uniform sampler2D screentex: hint_screen_texture, filter_nearest;
uniform int pixelation_level = 1;
uniform float crush = 1.75;

void vertex() {
	// Full screen quad trick: position vertices directly in NDC
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	int pixel = pixelation_level * 2;
	
	// Snap FRAGCOORD to the nearest pixel block
	vec2 snapped_frag = floor(FRAGCOORD.xy / float(pixel)) * float(pixel) + float(pixel) / 2.0;
	
	// Convert back to UV space
	vec2 pixel_uv = snapped_frag / VIEWPORT_SIZE;
	
	vec4 screen = texture(screentex, pixel_uv);
	
	float greyscale = max(screen.r, max(screen.g, screen.b));
	
	float low_color = floor(greyscale * crush) / crush;
	float high_color = ceil(greyscale * crush) / crush;
	
	float low_dif = abs(low_color - greyscale);
	float high_dif = abs(high_color - greyscale);
	
	float color_check = low_dif < high_dif ? low_dif : high_dif;
	
	float dither = color_check - greyscale;
	
	ALBEDO = screen.rgb + dither;
}
