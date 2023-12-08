precision highp float;

varying vec2 vUv;
uniform float uTime;
uniform vec2 uResolution;

// The most basic shader
void main(){
  vec3 color = vec3(1.);

  gl_FragColor = vec4(color, 1.0);
}
