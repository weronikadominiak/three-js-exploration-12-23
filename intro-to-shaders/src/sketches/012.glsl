precision highp float;

varying vec2 vUv;
uniform float uTime;
uniform vec2 uResolution;

vec3 palette(in float t) {
  vec3 a = vec3(0.7, 0.5, 1.5);
  vec3 b = vec3(-0.462, 0.5, 0.5);
  vec3 c = vec3(1.0, 1.0, 1.0);
  vec3 d = vec3(-1.1, 0.9, 0.927);

  return a + b * cos(6.28318 * (c * t + d));
}


float normalSin(float x){
  // make smaller and move to 0 - 1 range of sine wave instead of -1 to 1
  return sin(x) * 0.5 + 0.5;
}

float normalCos(float f){
  return .5 + .5 * cos(f);
}

// The most basic shader
void main(){
  vec2 uv = vUv * 2.0 - 1.0;
  vec2 uv0 = vUv;
  uv += 2.0;
  // uv = fract(uv);

  // draw a circle in the middle of the screen
  // distance here is a value from middle point 0.5 and our current point of specific pixel
  float dist = distance(vec2(0.5), uv);
  // make it have sharp edges with step function - if distance is less than 0.2, return 0, otherwise 1
  // float circle = step(0.2, dist);
  // dist =  distance(vec2(normalSin(uTime) / 12., normalCos(uTime) / 12.), uv);
  // dist= abs(dist - 0.1);
  dist = sin(dist * 10.  + uTime)/10. ; 


  // make it pulse with sine wave, using time as input => make it move with normalSin function, make it grow and shrink with normalSin function
  // float circle = step(0.1 * normalSin(uTime), dist);
  // // make it fade in an out by multiplying it with normalSin function
  // circle += normalSin(uTime);



  // vec3 col = palette(distance(uv0.y, 0.2) + uTime * 0.1);
  // vec3 fragColor = col * circle;

  vec3 fragColor = palette(distance(uv0.y, 0.2) + uTime * 0.1);


  for (float i = 0.0; i < 4.0; i++) {
    vec3 col = palette(length(uv0) + uTime * .4); 
    uv += fract(uv) * 20.;

    dist = abs(dist); 

    dist = 0.02 / dist; 
    fragColor += col * dist;
  }



  gl_FragColor = vec4(fragColor, 1.0);
}
