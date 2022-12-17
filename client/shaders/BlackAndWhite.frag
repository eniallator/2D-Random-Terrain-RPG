vec4 effect(in vec4 colour, in sampler2D texture, in vec2 texture_coords, in vec2 screen_coords ) {
    vec4 pixel = Texel(texture, texture_coords);
    lowp float pixelAvg = (pixel.r + pixel.g + pixel.b) / 3;

    pixel.r = pixelAvg;
    pixel.g = pixelAvg;
    pixel.b = pixelAvg;

    highp float colourAvg = (colour.r + colour.g + colour.b) / 3;

    vec4 blackWhiteVec = vec4(colourAvg, colourAvg, colourAvg, 1);

    return pixel * blackWhiteVec;
}
