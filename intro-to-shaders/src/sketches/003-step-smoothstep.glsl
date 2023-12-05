precision highp float;

varying vec2 vUv;
uniform float uTime;

float square(vec2 uv, float size){
  float halfSize = size / 2.0;
  float left = step(0.5 - halfSize, uv.x);
  float right = step(uv.x, 0.5 + halfSize);
  float bottom = step(0.5 - halfSize, uv.y);
  float top = step(uv.y, 0.5 + halfSize);

  return bottom * top * left * right;
}

float rectangle(vec2 uv, float size){
  float halfSize = size / 2.0;
  float left = step(0.5 - size, uv.x);
  float right = step(uv.x, 0.5 + size);
  float bottom = step(0.5 - halfSize, uv.y);
  float top = step(uv.y, 0.5 + halfSize);

  return bottom * top * left * right;
}

float circle(vec2 uv, float size){
  float circleGradient = distance(vec2(0.5), uv);
  float circle = step(size, circleGradient);

  return circle;
}

float movingCircle(vec2 uv, float size){
  vec2 circlePosition = vec2(cos(uTime), sin(uTime) * 0.2);
  float sizeChange = sin(uTime) * 0.2;

  float circleGradient = distance(vec2(size), uv + circlePosition);
  // float circle = step(size + sizeChange, circleGradient);
  float circle = smoothstep(0.2 + sizeChange, 0.4 + sizeChange, distance(vec2(0.5), uv + circlePosition));

  return circle;
}

void main(){
  vec2 uv = vUv;

  // float result = rectangle(uv, 0.2);
  // float result = square(uv, 0.2);
  // float result = smoothstep(0.3, 0.7, uv.x);
  // float result = circle(uv, 0.4);
  float result = movingCircle(uv, 0.2);

  vec3 color = vec3(result);

  gl_FragColor = vec4(color, 1.0);
}

