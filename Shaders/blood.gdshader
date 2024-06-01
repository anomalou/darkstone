shader_type canvas_item;

uniform sampler2D decal : filter_nearest;
uniform float damage;

void fragment() {
	vec4 decal_color = texture(decal, UV);
	vec4 color = texture(TEXTURE, UV);
	
	if (decal_color.a != .0 && color.a != .0 && decal_color.r > damage) {
		COLOR.rgb = vec3(decal_color.r, .0, .0);
	} else {
		COLOR = color;
	}
}

