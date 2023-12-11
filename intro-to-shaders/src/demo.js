import "./style.css"
import { gsap } from "gsap"
import { Rendering } from "./rendering"
import * as THREE from "three";

import {  catchThreeJSErrors,  setupSketchControls } from "./utils";


// -- Sketch management trickery
//

const sketches = import.meta.glob('./sketches/*.glsl',{ as: 'raw', eager: true })
let filenames = Object.keys(sketches).map(path => path.split(/[\\/]/).pop())

let search = new URLSearchParams(window.location.search)
 let selectedSketch = search.get("filename") == null ? filenames[0] : search.get("filename") 

let filenameEle = document.querySelector("#filename")
filenameEle.innerText = selectedSketch

setupSketchControls(selectedSketch, filenames)

catchThreeJSErrors()

// -- Actual rendering stuff
//

let rendering = new Rendering(document.querySelector("#canvas"))

let uTime = new THREE.Uniform(0)

let uResolution = new THREE.Uniform({x: rendering.canvas.width, y: rendering.canvas.height})

let test = { value: 0 };



//-- Audio Analyser
//https://threejs.org/docs/#api/en/audio/AudioAnalyser

// create an AudioListener and add it to the camera
const listener = new THREE.AudioListener();
rendering.camera.add( listener );

// create an Audio source
const sound = new THREE.Audio( listener );

// load a sound and set it as the Audio object's buffer
const audioLoader = new THREE.AudioLoader();
audioLoader.load( '/examples_sounds_376737_Skullbeatz___Bad_Cat_Maste.ogg', function( buffer ) {
// audioLoader.load( '/examples__audio_song.mp3', function( buffer ) {
  sound.setBuffer( buffer );
	sound.setLoop(true);
	sound.setVolume(0.5);
	sound.play();
});

const fftSize = 256;
// create an AudioAnalyser, passing in the sound and desired fftSize
const analyser = new THREE.AudioAnalyser( sound, fftSize );

// const averageFreq = analyser.getAverageFrequency();
const format = THREE.RedFormat; // todo


// console.log(analyser.data, frequencyData);
let tAudioData =  { value: new THREE.DataTexture( analyser.data, fftSize / 2, 1, format ) };
const uniforms = {
    uTime: uTime,
    uResolution: uResolution,
    tAudioData,
    test: test
  }

const plane = new THREE.PlaneGeometry()
const fullscreenMaterial = new THREE.RawShaderMaterial({
  vertexShader: glsl`
    precision highp float;
    attribute vec3 position;
    attribute vec2 uv;

    varying vec2 vUv;
    void main(){ 
      vec3 transformed = position;
      transformed.xy *= 2.;
      vUv = uv;
      gl_Position = vec4(transformed, 1.);
    }
`,
  fragmentShader: sketches["./sketches/"+selectedSketch],
  uniforms,
})

console.log({  value: new THREE.DataTexture( analyser.data, fftSize / 2, 1, format ) })
const mesh = new THREE.Mesh(plane, fullscreenMaterial)

rendering.scene.add(mesh)


function tick (time, delta){
  uTime.value += delta * 0.001;
  analyser.getFrequencyData();
  tAudioData.value.needsUpdate = true;
  rendering.render()

}

gsap.ticker.add(tick)



