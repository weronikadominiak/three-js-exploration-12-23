precision highp float;

varying vec2 vUv;
uniform float uTime;

void main(){
  vec3 color = vec3(1., 0., 0.);

  if(vUv.x > 0.5){
    color = vec3(0.2, 1., 1.);
  }

  gl_FragColor = vec4(color, 1.0);
}

