precision highp float; // Add default precision qualifier for float

varying highp vec3 vColor;
varying highp vec3 vNormal;
varying highp vec3 vLightPosition;

void main() {
    const float ambient = 0.5;
    vec3 light = vLightPosition;
    light = normalize(light);
    float directional = max(dot(vNormal, light), 0.0);

    gl_FragColor = vec4((directional + ambient) * vColor, 1.0);
}
