precision highp float;

varying vec2 vUv;
uniform float uTime;
uniform vec2 uResolution;

// 6.28318 is PI * 2 - the exact point where the wave repeats
// use http://dev.thi.ng/gradients/ to generate gradients
vec3 palette(in float t) {
  vec3 a = vec3(0.7, 0.5, 1.5);
  vec3 b = vec3(-0.462, 0.5, 0.5);
  vec3 c = vec3(1.0, 1.0, 1.0);
  vec3 d = vec3(-1.1, 0.9, 0.927);

  return a + b * cos(6.28318 * (c * t + d));
}


void main(){
  vec2 uv = vUv * 2.0 - 1.;
  vec2 uv0 = uv;
  vec3 finalColor = vec3(0.0);

  for (float i = 0.0; i < 4.0; i++) {
    // uv = fract(uv * 2.0) - 0.5;
    uv = fract(uv * 1.) - 0.5; // breaking symetry by using decimal numbers

    // float d = length(uv);
    float d = length(uv) * exp(-length(uv0)); // icreasing variation by using global distance depending on the center of the canvas, use https://graphtoy.com/ to visualise


    // vec3 col = palette(length(uv0) + uTime; 
    // vec3 col = palette(length(uv0) + uTime * .4); 
    vec3 col = palette(length(uv0) + i*.4 + uTime * .4);  // adding i to increase variations


    d = sin(d * 20. + uTime)/20.; 
    d = abs(d); 

    // d = 0.02 / d; 
    // d = 0.01 / d; 
    d = pow(0.01 / d, 2.); // create bigger contrast between colors, the ones closer to 0 will be darker

    finalColor += col * d;
  }


  vec4 fragColor = vec4(finalColor, 1.0);

  gl_FragColor = fragColor;
}