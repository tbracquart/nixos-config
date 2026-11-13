//
// Style personnalisé : vignette subtile + grain léger.
// Appliqué via decoration.screen_shader.
//

#version 300 es

precision mediump float;
in vec2 v_texcoord;
layout(location = 0) out vec4 fragColor;
uniform sampler2D tex;

const float VIGNETTE_STRENGTH = 0.15;
const float VIGNETTE_RADIUS   = 0.75;
const float GRAIN_STRENGTH    = 0.015;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

void main() {
    vec4 pixColor = texture(tex, v_texcoord);

    vec2 centered = v_texcoord - 0.5;
    float dist = length(centered) * 2.0;
    float vignette = smoothstep(VIGNETTE_RADIUS, 1.25, dist);
    pixColor.rgb *= 1.0 - vignette * VIGNETTE_STRENGTH;

    float grain = (hash(gl_FragCoord.xy) - 0.5) * GRAIN_STRENGTH;
    pixColor.rgb += grain;

    fragColor = pixColor;
}
