precision highp float;

varying vec2 vUv;
uniform float uTime;

float normalSin(float x){
  // make smaller and move to 0 - 1 range of sine wave instead of -1 to 1
  return sin(x) * 0.5 + 0.5;
}

// void main(){
//   vec2 uv = vUv;
//   vec3 color = vec3(1.);

//   float edge = normalSin(uTime); 
//   float gradient = step(edge, uv.x);
//   vec3 result = vec3(gradient);

//   gl_FragColor = vec4(result, 1.0);
// }


// TODO play with this one more - use multiple rectangles with multiple color gradients
// void main(){
//   vec2 uv = vUv;
//   vec3 color = vec3(1.);

//   float edge = normalSin(uTime); 
//   float infinite = normalSin(uv.x + uTime);
//   float fastAndFrequent = normalSin(uv.x * 1. + uTime * 3.);

//   // vec3 result = vec3(infinite);
//   vec3 result = vec3(fastAndFrequent);

//   gl_FragColor = vec4(result, 1.0);
// }


// void main() {
//   vec3 color = vec3(1.);
//   vec2 uv = vUv;
//   float result = 0.;

//   // Modify UV before using it
//   uv.x = normalSin(uv.x * 10.);
//   uv.y = normalSin(uv.y * 10.);

//   vec2 pos = vec2(cos(uTime), sin(uTime)) * 0.2;
//   float sizeChange = sin(uTime * 2.) * 0.2;

//   float circle = smoothstep(0.2 + sizeChange, 0.4 + sizeChange, distance(vec2(0.5), uv + pos));

//   result += circle;
//   color = vec3(result);

//   gl_FragColor = vec4(color, 1.0);
// }

// NOTE:
// Sine and cosine are used to create circles, so input is a radian angle, so function repeats at PI * 2 and output is a 2D position; sine returns Y and cosine X
// Frequency = how often wave repeates - done by multiplying inside sin/cos - sin(ux.x * frequency)
// Amplitude = how high the wave goes - done by multiplying outside sin/cos - sin(ux.x) * amplitude
// Displacement = how far the wave is from the center - done by adding to sin/cos - sin(ux.x + displacement) => like uTime

// 6.28318 is PI * 2 - the exact point where the wave repeats
vec3 palette(in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d) {
  return a + b * cos(6.28318 * (c * t + d));
}

void main() {
  vec3 color = vec3(1.);
  vec2 uv = vUv;
  float result = 0.;

  // Modify UV before using it
  uv.x = normalSin(uv.x * 30.);
  uv.y = normalSin(uv.y * 30.);

  vec2 pos = vec2(cos(uTime), sin(uTime)) * 0.2;
  float sizeChange = sin(uTime * 2.) * 0.2;

  float circle = smoothstep(0.2 + sizeChange, 0.4 + sizeChange, distance(vec2(0.5), uv + pos));

  result += circle;
  color = vec3(result);
  
  // add colour outisde shapes
  float paletteOffset = vUv.x * 0.3 + vUv.y + uTime * 0.2;

  // switch colour to inside shapes
  result = 1. - result; // this is used to flip the colours
  color = result * palette(paletteOffset, vec3(0.5, 0.5, 0.5), vec3(0.5, 0.5, 0.5), vec3(2.0, 1.0, 0.0), vec3(0.5, 0.20, 0.25));



  gl_FragColor = vec4(color, 1.0);
}

