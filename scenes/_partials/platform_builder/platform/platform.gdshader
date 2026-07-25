shader_type canvas_item;

const vec4 SRC_LIGHT_GRAY = vec4(0.678, 0.694, 0.788, 1.0); // adb1c9
const vec4 SRC_DARK_BLUE  = vec4(0.129, 0.141, 0.208, 1.0); // 212435
const vec4 SRC_MED_GRAY   = vec4(0.447, 0.459, 0.565, 1.0); // 727590
const vec4 SRC_NEW_BLUE   = vec4(0.224, 0.243, 0.357, 1.0); // 393e5b
const vec4 SRC_MID_BLUE   = vec4(0.341, 0.357, 0.459, 1.0); // 575b75
const vec4 SRC_LIGHT_BLUE = vec4(0.490, 0.518, 0.667, 1.0); // 7d84aa

group_uniforms Level_Colors;
uniform vec4 target_light_gray : source_color = vec4(0.678, 0.694, 0.788, 1.0);
uniform vec4 target_dark_blue  : source_color = vec4(0.129, 0.141, 0.208, 1.0);
uniform vec4 target_med_gray   : source_color = vec4(0.447, 0.459, 0.565, 1.0);
uniform vec4 target_new_blue   : source_color = vec4(0.224, 0.243, 0.357, 1.0);
uniform vec4 target_mid_blue   : source_color = vec4(0.341, 0.357, 0.459, 1.0);
uniform vec4 target_light_blue : source_color = vec4(0.490, 0.518, 0.667, 1.0);

group_uniforms Adjustments;
uniform float color_match_precision : hint_range(0.0, 0.1) = 0.01;
uniform float brightness : hint_range(-1.0, 1.0) = 0.0;
uniform float saturation : hint_range(0.0, 2.0) = 1.0;

void fragment() {

    vec4 current_color = texture(TEXTURE, UV);
    
    if (distance(current_color.rgb, SRC_LIGHT_GRAY.rgb) < color_match_precision) {
        current_color.rgb = target_light_gray.rgb;
    } 
    else if (distance(current_color.rgb, SRC_DARK_BLUE.rgb) < color_match_precision) {
        current_color.rgb = target_dark_blue.rgb;
    } 
    else if (distance(current_color.rgb, SRC_MED_GRAY.rgb) < color_match_precision) {
        current_color.rgb = target_med_gray.rgb;
    }
    else if (distance(current_color.rgb, SRC_NEW_BLUE.rgb) < color_match_precision) {
        current_color.rgb = target_new_blue.rgb;
    }
    else if (distance(current_color.rgb, SRC_MID_BLUE.rgb) < color_match_precision) {
        current_color.rgb = target_mid_blue.rgb;
    }
    else if (distance(current_color.rgb, SRC_LIGHT_BLUE.rgb) < color_match_precision) {
        current_color.rgb = target_light_blue.rgb;
    }
    
    current_color.rgb += brightness;
    
    float luma = dot(current_color.rgb, vec3(0.299, 0.587, 0.114));
    current_color.rgb = mix(vec3(luma), current_color.rgb, saturation);
    
    COLOR = current_color;
}
