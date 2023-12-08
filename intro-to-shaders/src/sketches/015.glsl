precision highp float;

varying vec2 vUv;
uniform float uTime;
uniform vec2 uResolution;

// reference https://www.shadertoy.com/view/XsX3zS 


// The most basic shader
void main(){
  vec2 uv = vUv * 2. -1.;
  // vec2 uv0 = vUv;
  vec3 fragColor = vec3(0.0, 0.0, 0.1);
  const float WAVES = 10.0;
  
  // generate multiple waves  for each pixel
  for(float i = 0.0; i < WAVES; i++) {
    float frequency = sin(uTime) * i * 0.3;  // set slightly different frequency for each wave, this will be replaced by the frequency of the audio

     // position the wave
    vec2 pos = vec2(uv);
    // move the wave along the x axis based on the frequency and number of the wave
    pos.x += i * 0.02 + frequency * 0.25;
    // add some noise to the y position
    pos.y += sin(pos.x * 4.5 + uTime) * cos(pos.x * 2.0) * frequency * 0.2 * ((i + 1.0) / WAVES);


    // intensity of the wave is used to modulate the color of the final pixel
    float glowIntensity = abs(0.01 / pos.y) * clamp(frequency, 0.2, 1.0);  // abs is used to normalize the wave and make sure pos is always positive - te clamp is used to make sure the glow is not too strong, the bigger frequency the stronger the glow

    // add the color of the wave to the final color
    float red = .05 * glowIntensity * (i / 2.0);
    float green = 1.0 * glowIntensity;
    float blue = 0.5 * glowIntensity * ((i + 1.0) / WAVES);

    fragColor += vec3(red, green, blue);
  };


  gl_FragColor = vec4(fragColor, 1);

}
