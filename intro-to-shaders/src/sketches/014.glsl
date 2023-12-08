precision highp float;

varying vec2 vUv;
uniform float uTime;
uniform vec2 uResolution;


float normalSin(float x){
  // make smaller and move to 0 - 1 range of sine wave instead of -1 to 1
  return sin(x) * 0.5 + 0.5;
}

float normalCos(float f){
  return .5 + .5 * cos(f);
}

// The most basic shader
void main(){
  vec2 uv = vUv;
  vec4 fragColor = vec4(1.0, 0.0, 1.0, 1.0);

  uv.y = fract(uv.y * 3. * sin(uTime * 0.5));
    // Modify UV before using it
  // uv.x = normalSin(uv.x * 2.);
  // uv.y = normalSin(uv.y * 30.);


// // draw a line
//   float dist = distance(uv.y, 0.5);
//   float line = step(0.001, dist);
//   fragColor = vec4(line, 0.5, 1.0, 1.0);

  // create a wave
  float frequency = 5.0; 
  float amplitude = 0.1;
  float timeFactor = uTime * 5.;  // Use time to animate the wave
  float wave = amplitude * normalSin(uv.x * frequency + timeFactor);

  // draw the wave
  float dist = distance(uv.y, 0.5 + wave);
  float line = step(0.010, dist);
  fragColor = vec4(line, 0.2, 0.5, 1.0);


  gl_FragColor = fragColor;

}
