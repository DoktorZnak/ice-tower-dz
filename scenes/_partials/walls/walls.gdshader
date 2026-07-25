shader_type canvas_item;

// Kolory źródłowe z ludzkimi nazwami
const vec4 SRC_WHITE      = vec4(0.996, 1.000, 1.000, 1.0); // feffff
const vec4 SRC_LIGHT_GRAY = vec4(0.671, 0.690, 0.784, 1.0); // acb0c8
const vec4 SRC_MED_GRAY   = vec4(0.447, 0.459, 0.565, 1.0); // 727590
const vec4 SRC_SLATE_BLUE = vec4(0.341, 0.357, 0.459, 1.0); // 575b75
const vec4 SRC_DARK_BLUE  = vec4(0.243, 0.251, 0.314, 1.0); // 3e4050
const vec4 SRC_DEEP_NAVY  = vec4(0.129, 0.141, 0.208, 1.0); // 212435

group_uniforms Level_Colors;
uniform vec4 target_white      : source_color = vec4(0.996, 1.000, 1.000, 1.0);
uniform vec4 target_light_gray : source_color = vec4(0.671, 0.690, 0.784, 1.0);
uniform vec4 target_med_gray   : source_color = vec4(0.447, 0.459, 0.565, 1.0);
uniform vec4 target_slate_blue : source_color = vec4(0.341, 0.357, 0.459, 1.0);
uniform vec4 target_dark_blue  : source_color = vec4(0.243, 0.251, 0.314, 1.0);
uniform vec4 target_deep_navy  : source_color = vec4(0.129, 0.141, 0.208, 1.0);

group_uniforms Adjustments;
uniform float color_match_precision : hint_range(0.0, 0.1) = 0.01;
uniform float brightness : hint_range(-1.0, 1.0) = 0.0;
uniform float saturation : hint_range(0.0, 2.0) = 1.0;

void fragment() {
    vec4 current_color = texture(TEXTURE, UV);
    
    if (distance(current_color.rgb, SRC_WHITE.rgb) < color_match_precision) {
        current_color.rgb = target_white.rgb;
    } 
    else if (distance(current_color.rgb, SRC_LIGHT_GRAY.rgb) < color_match_precision) {
        current_color.rgb = target_light_gray.rgb;
    } 
    else if (distance(current_color.rgb, SRC_MED_GRAY.rgb) < color_match_precision) {
        current_color.rgb = target_med_gray.rgb;
    } 
    else if (distance(current_color.rgb, SRC_SLATE_BLUE.rgb) < color_match_precision) {
        current_color.rgb = target_slate_blue.rgb;
    } 
    else if (distance(current_color.rgb, SRC_DARK_BLUE.rgb) < color_match_precision) {
        current_color.rgb = target_dark_blue.rgb;
    } 
    else if (distance(current_color.rgb, SRC_DEEP_NAVY.rgb) < color_match_precision) {
        current_color.rgb = target_deep_navy.rgb;
    } 

    current_color.rgb += brightness;
    float luma = dot(current_color.rgb, vec3(0.299, 0.587, 0.114));
    current_color.rgb = mix(vec3(luma), current_color.rgb, saturation);
    
    COLOR = current_color;
}
