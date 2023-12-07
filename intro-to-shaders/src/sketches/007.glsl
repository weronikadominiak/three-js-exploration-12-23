precision highp float;

varying vec2 vUv;
uniform float uTime;

// Swizzling is okay in GLSL

void main(){
  // vec2 uv = vUv / iResolution.xy; // iresolution is glbal var avaialable in shader toy - this helps with scaling the shader to the screen size
  vec2 uv = vUv;


  // at this point center of the canvas is at 0.5, 0.5, we want to move it to be at 0, 0 so it matches our coordinates, so
  uv = uv - 0.5; // this will move the center of the canvas to 0, 0, but now the corners are at -0.5, -0.5, 0.5, 0.5, so we need to scale it down to -1, 1, so:
  uv = uv * 2.0; // this will scale it down to -1, 1
  // uv.x = iResolution.x / iResolution.y * uv.x; // this would keep aspect ratio, I haven't checked yet what iResolution equivalent is in three.js, at the moment I have no problems here because my canvas is always square; In theory all lines above could be simplified to:
  // vec2 uv = (vUv * 2.0 - iResolution.xy) / iResolution.y; // this is the same as above -  I am assuming my vUv is shader toy's fragCoord



  // length function - returns the length of the vector, so the distance from 0, 0 to the point on the canvas - so the distance between vector and the origin
  float d = length(uv);

  // SDF - sine distance function - function that takes a position in space as input and returns the distance from that position to given shape - sine because distance is positive outside of the shape and negative inside of the shape, and exactly 0 at the boundary of the shape, so it's like sine wave
  // list of useful SDFs https://iquilezles.org/articles/distfunctions2d/
  d -= .5; // this now creates sine distance function of a cirlce with r = 0.5, so the gradient we see represents sine distance to a circle with a radious 0.5

  d = abs(d); // this makes distance increase as we get further away from dcircle's edges, so it's white in the center, black on the edges and white on the outside of the circle

  // to make sharp edges we can use step function:
  // d = step(.1, d); // all pixels with d < 0.1 will be black, all pixels with d > 0.1 will be white, so we get a circle with sharp edges

  // to make transition between white and black smooth we can use smoothstep function:
  d = smoothstep(0.0, .1, d); // this will make the transition between white and black smooth, so we get a circle with smooth edges


  vec4 fragColor = vec4(d, 0, 0., 1.0);  // this makes radial gradient - black in the center and red on the edges - further away from the center the value is bigger, so the color is more red
  fragColor = vec4(d, d, d, 1.0); // grayscale radial gradient


  // vec4 fragColor = vec4(uv.x, 0., 0., 1.0); // this is gradient - black on the left and red on the right - it's because uv.x is 0 on the left and 1 on the right, if I would use uv.y it would be black on the bottom and red on the top
  // vec4 fragColor = vec4(uv.x, uv.y, 0., 1.0); // with this I get green on the top left and red on the bottom right, with a bit of dark on the bottom left, this is bcause on the bottom left both values are 0 and on the top both are 1, so its green + red = yellow, this can be also written as vec4(uv, 0., 1.); because uv contains both x and y values


  gl_FragColor = fragColor;
}








