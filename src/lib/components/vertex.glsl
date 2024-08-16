uniform vec2 mousePosition;
uniform vec3 lightPosition;
attribute vec3 displacement;
attribute vec3 color;

varying vec3 vColor;
varying vec3 vNormal;
varying vec3 vLightPosition;

void main() {
    vColor = color;
    vNormal = normal;
    vLightPosition = lightPosition;

    float dist = min(1.0 - distance(position.zx, -mousePosition), 0.0);
    vec3 newPosition = position + normal * displacement * dist;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(newPosition, 1.0);
}
