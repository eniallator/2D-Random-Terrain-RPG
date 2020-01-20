uniform highp float V;

vec4 effect(in vec4 colour, in sampler2D texture, in vec2 texture_coords, in vec2 screen_coords ) {
    highp float H = texture_coords.x;
    highp float S = 1 - texture_coords.y;

    highp float HDegrees = 6 * H;

    highp float C = V * S;
    highp float X = C * (1 - abs(mod(HDegrees, 2) - 1));
    highp float m = V - C;

    highp float RPrime = abs(HDegrees - 3) >= 2 ? C : abs(HDegrees - 3) >= 1 ? X : 0;
    highp float GPrime = HDegrees >= 4 ? 0 : abs(HDegrees - 2) >= 1 ? X : C;
    highp float BPrime = HDegrees < 2 ? 0 : abs(HDegrees - 4) >= 1 ? X : C;

    highp float R = RPrime + m;
    highp float G = GPrime + m;
    highp float B = BPrime + m;

    vec4 outVec = vec4(R, G, B, 1);

    return outVec;
}
