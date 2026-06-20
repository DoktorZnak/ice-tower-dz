shader_type canvas_item;

// Adjust if outlines bleed, but 0.1 works perfectly for black outlines
uniform float tolerance : hint_range(0.0, 1.0) = 0.1; 

void fragment() {
    // 1. Automatically grab the background color from the very top-left pixel
    vec4 bg_color = texture(TEXTURE, vec2(0.0, 0.0));
    vec4 current_color = texture(TEXTURE, UV);
    
    // 2. Check if the current pixel matches the purple background
    float dist = distance(current_color.rgb, bg_color.rgb);
    
    if (dist < tolerance) {
        // 3. To protect the hat, we check if this pixel is inside the character.
        // We look at neighboring pixels. If they are completely empty space, 
        // it confirms this pixel is part of the outer background.
        vec2 size = TEXTURE_PIXEL_SIZE;
        vec4 up    = texture(TEXTURE, UV + vec2(0.0, -size.y));
        vec4 down  = texture(TEXTURE, UV + vec2(0.0, size.y));
        vec4 left  = texture(TEXTURE, UV + vec2(-size.x, 0.0));
        vec4 right = texture(TEXTURE, UV + vec2(size.x, 0.0));
        
        float up_dist    = distance(up.rgb, bg_color.rgb);
        float down_dist  = distance(down.rgb, bg_color.rgb);
        float left_dist  = distance(left.rgb, bg_color.rgb);
        float right_dist = distance(right.rgb, bg_color.rgb);
        
        // If it's surrounded by background, discard it.
        // If it's near an outline, it keeps it safe.
        if (up_dist < tolerance || down_dist < tolerance || left_dist < tolerance || right_dist < tolerance) {
            discard;
        }
    }
    
    COLOR = current_color;
}