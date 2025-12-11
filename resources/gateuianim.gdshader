shader_type canvas_item;

void fragment() {
	float frame = float(int(TIME * 20.0) % 10);
	COLOR = texture(TEXTURE, UV + vec2(0.0 + frame * 0.1, 0.0));
}

