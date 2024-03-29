shader_type canvas_item;
uniform sampler2D tex;
uniform float opacity:hint_range(0.0, 1.0, 0.001) = 1.0;

void fragment() {
    COLOR = vec4(texture(tex, UV).rgb , opacity);
}