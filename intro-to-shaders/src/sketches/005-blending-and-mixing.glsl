precision highp float;

varying vec2 vUv;
uniform float uTime;

float square(vec2 uv, float size){
	float halfSize = size/2.;
	float left   = step(0.5 - halfSize, uv.x);
	float right  = step(uv.x, 0.5 + halfSize);

	float top    = step(0.5 - halfSize, uv.y);
	float bottom = step(uv.y, 0.5 + halfSize );

  return left * right * top * bottom;
}

float normalSin(float val){
		return sin(val) * 0.5 + 0.5;
}

vec3 palette( in float t, in vec3 a, in vec3 b, in vec3 c, in vec3 d ){
  return a + b*cos( 6.28318*(c*t+d) );
}

// void main(){
//   vec3 color = vec3(1.);
//   vec2 uv = vUv;

//   vec3 red = vec3(1., 0., 0.);
//   vec3 blue = vec3(0., 0., 1.);
//   vec3 redToBlue = mix(red, blue, uv.x);
//   vec3 redToBlueSplit = mix(red, blue, step(0.5, uv.x));
//   vec3 circle = mix(red, blue, distance(vec2(0.5), uv));
//   vec3 green = vec3(0., 1., 0.);
  

//   // color = mix(red, blue, 0.5);
//   // color = redToBlue;
//   // color = circle;
//   color = redToBlueSplit + green * uv.y;
//   // color = mix(redToBlueSplit, green, uv.y);

//   gl_FragColor = vec4(color, 1.0);
// }


// void main(){
//   vec3 color = vec3(1.);
//   vec2 uv = vUv;

//   float squares = square(uv, 0.6 + sin(uTime) * 0.2);
//   squares -= square(uv, 0.2 + cos(uTime) * 0.2);


//   color= vec3(squares);
  
//   gl_FragColor = vec4(color, 1.0);
// }

void main(){
  vec3 color = vec3(1.);
  vec2 uv = vUv;

  float repeat = normalSin(uTime);

  float dist = distance(vec2(0.5), uv);
  repeat = 0.;
  uv.x += mix(sin(dist * 100. - uTime * 8.) * 0.3, 0., repeat);
  uv.y += mix(cos(dist * 100. - uTime * 8.) * 0.3, 0., repeat);

  // create squares
  float squares = square(uv, 0.6 + sin(uTime) * 0.2);
  squares -= square(uv, 0.2 + cos(uTime) * 0.2);


  // palettes
  float paletteOffset = dist - uTime * 0.2;
  vec3 firstPalette = palette(paletteOffset, vec3(0.5,0.5,0.5),vec3(0.5,0.5,0.5),vec3(2.0,1.0,0.0),vec3(0.5,0.20,0.25));

  vec3 secondPalette = palette(paletteOffset * 2., vec3(0.8,0.5,0.4),vec3(0.2,0.4,0.2),vec3(2.0,1.0,1.0),vec3(0.0,0.25,0.25));

  // Blend in the middle
  color = mix(firstPalette, secondPalette, smoothstep(0.4,.6, vUv.x));
    // color = mix(firstPalette, secondPalette, smoothstep(0.4,.6, uv.x));


    // fade corners 
  float cornerFade =  smoothstep(0.5, .2, dist);
  color = mix(vec3(0.), color, squares * cornerFade );
  
  gl_FragColor = vec4(color, 1.0);
}


