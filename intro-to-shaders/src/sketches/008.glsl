precision highp float;

varying vec2 vUv;
uniform float uTime;

// 6.28318 is PI * 2 - the exact point where the wave repeats
// use http://dev.thi.ng/gradients/ to generate gradients
vec3 palette(in float t) {
  vec3 a = vec3(0.7, 0.5, 0.5);
  vec3 b = vec3(-0.462, 0.5, 0.5);
  vec3 c = vec3(1.0, 1.0, 1.0);
  vec3 d = vec3(-1.1, 0.9, 0.927);

  return a + b * cos(6.28318 * (c * t + d));
}


void main(){
  vec2 uv = vUv;
  vec2 uv0 = uv; // original uv
  uv = (uv - 0.5) * 2.0;

  // introduce spacial repetition
  // fract function returns the fractional part of it's input extracting only the didgets after decimal point, so results are from 0 to 1
  // uv = fract(uv); // this will create a 0-1 range instead of desired clipped space,to fix it scale uv first and then substract 0.5 to center the space
  // uv += 2.0;
  // uv = fract(uv);
  // uv -= 0.5;
  // that can be shortened to:
  uv = fract(uv * 2.0) - 0.5;

  float d = length(uv);
  // vec3 col = palette(d * uTime);  // defining color
  vec3 col = palette(length(uv0) * uTime * 0.2);  // replacing d with uv0 will create a gradient from the center of the screen - avoid local repetition


  // d = sin(d * 8.)/8.; // using sin here will create repetition of the rings, we are multiplying because we wouldn't see a difference with 1 and we would see only one circle. Multiplying the distance by 8 stretches the space and alters the color intensity requiring coresponding division by the same number

  d = sin(d * 8. + uTime)/8.; // thanks to sine repetitive nature, we can create infinite loop of rings
  d = abs(d); // we need to make sure that the distance is always positive, otherwise we would get negative values and the rings would be inverted

  d = 0.02 / d; // inverting d, 0.02 adds neon like glow

  col *= d; // adding distance to the color

  vec4 fragColor = vec4(col, 1.0);

  gl_FragColor = fragColor;
}