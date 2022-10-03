vec4 effect(in vec4 colour, in sampler2D texture, in vec2 texture_coords, in vec2 screen_coords ) {
    return vec4(texture_coords.x, texture_coords.x, texture_coords.x, 1);
}
