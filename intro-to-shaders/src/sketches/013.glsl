precision highp float;

varying vec2 vUv;
uniform float uTime;
uniform vec2 uResolution;

vec3 palette(in float t) {
  vec3 a = vec3(0.5, 0.5, 1.5);
  vec3 b = vec3(-0.462, 0.5, 0.5);
  vec3 c = vec3(1.0, 1.0, 1.0);
  vec3 d = vec3(-1.1, 0.9, 0.927);

  return a + b * cos(6.28318 * (c * t + d));
}

// The most basic shader
void main(){
  vec2 uv = vUv * 2.0 - 1.;
  vec2 uv0 = uv;
  uv += 2.0;
  uv = fract(uv);


  vec3 fragColor = palette(distance(uv0.y, 0.2) + uTime * 0.1);


  for (float i = 0.0; i < 6.0; i++) {
    float dist = distance(vec2(0.5), uv);
    dist = sin(dist * 10.  + uTime)/10. ; 
    dist = abs(dist); 
    dist = 0.02 / dist; 


    vec3 col = palette(length(uv0) + uTime * .4); 

    fragColor += col * dist;
  }



  gl_FragColor = vec4(fragColor, 1.0);
}
