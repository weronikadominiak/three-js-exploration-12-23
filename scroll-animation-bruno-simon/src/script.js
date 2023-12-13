import * as THREE from 'three'
import GUI from 'lil-gui'
import gsap from 'gsap';
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader";
import { TextGeometry } from 'three/examples/jsm/geometries/TextGeometry.js'
import { FontLoader } from 'three/examples/jsm/loaders/FontLoader.js'



/**
 * Debug
 */
const gui = new GUI()

const parameters = {
    materialColor: '#d6fc52',
    particlesColor: '#d1bbf7',
}

gui
    .addColor(parameters, 'materialColor')
    .onChange(() => {
        material.color.set(parameters.materialColor)
    })
gui
    .addColor(parameters, 'particlesColor')
    .onChange(() => {
        particlesMaterial.color.set(parameters.particlesColor)
    })

/**
 * Base
 */
// Canvas
const canvas = document.querySelector('canvas.webgl')

// Scene
const scene = new THREE.Scene()



/**
 * Objects 
 */

// Texture
const textureLoader = new THREE.TextureLoader();
const gradientTexture = textureLoader.load('textures/gradients/5.jpg');
gradientTexture.magFilter = THREE.NearestFilter;

// Material
const material = new THREE.MeshToonMaterial({ 
    gradientMap: gradientTexture,
    color: parameters.materialColor 
}) // Remember this material is light based - won't work without! 

// Meshes
const objectsDistance = 4;



const mesh2 = new THREE.Mesh(
    new THREE.TorusGeometry(1, 0.4, 16, 60),
    material
)

const mesh3 = new THREE.Mesh(
    new THREE.TorusKnotGeometry(0.8, 0.35, 100, 16),
    material
)


/**
 * Fonts
 */
const fontLoader = new FontLoader()

let textRotation = {
    x: 0.1,
    y: 0.1,
}

let text;
fontLoader.load(
    '/fonts/helvetiker_regular.typeface.json',
    (font) =>
    {
        const textGeometry = new TextGeometry(
            'vochlea',
            {
                font: font,
                size: 0.60,
                height: 0.18,
                curveSegments: 6,
                bevelEnabled: true,
                bevelThickness: 0.02,
                bevelSize: 0.05,
                bevelOffset: 0,
                bevelSegments: 4,
            }
        )
        const textMaterial = material;
        text = new THREE.Mesh(textGeometry, textMaterial);
        text.position.x = -3;
        text.rotation.x = textRotation.x;
        text.rotation.y = textRotation.y;
        scene.add(text)
    }
)



gui
    .add(textRotation, 'x', -12, 12, 0.01)
    .onChange(() => {
        text.rotation.x = textRotation.x
    })

gui
    .add(textRotation, 'y', -12, 12, 0.01)
    .onChange(() => {
        text.rotation.y = textRotation.y
    })


// load model
let model;
const gltfLoader = new GLTFLoader();
// gltfLoader.load("vmodels/ochlea-logo.gltf", (gltf) => {
// gltfLoader.load("models/vochlea-logo-smooth.gltf", (gltf) => {
gltfLoader.load("models/vochlea-logo-smooth2.gltf", (gltf) => {
    model = gltf.scene;

    model.scale.set(0.5, 0.5, 1);
    model.name= "logo";
    model.position.x =  1.8;

    scene.add(model);
});

// mesh1.position.y = - objectsDistance * 0;
mesh2.position.y = - objectsDistance * 1;
mesh3.position.y = - objectsDistance * 2;



mesh2.position.x = - 2;
mesh3.position.x = 2;


scene.add(mesh2, mesh3);

const sectionMeshes = [mesh2, mesh3];


/**
 * Particles
 */
// Geometry
const particlesCount = 200;
const positions = new Float32Array(particlesCount * 3)

for (let i = 0; i < particlesCount; i++) {
    positions[i * 3 + 0] = (Math.random() - 0.5) * 10; // x
    positions[i * 3 + 1] = objectsDistance * 0.5 - Math.random() * objectsDistance * (sectionMeshes.length +1);
    positions[i * 3 + 2] = (Math.random() - 0.5) * 10; // z 
}

const particlesGeometry = new THREE.BufferGeometry();
particlesGeometry.setAttribute('position', new THREE.BufferAttribute(positions, 3));

// Material
const particlesMaterial = new THREE.PointsMaterial({
    color: parameters.particlesColor,
    sizeAttenuation: true,
    size: 0.03
})

// Points
const particles = new THREE.Points(particlesGeometry, particlesMaterial);
scene.add(particles);

/**
 * Lights
 */
const directionalLight = new THREE.DirectionalLight('#ffffff', 3);
directionalLight.position.set(1, 1, 1);
scene.add(directionalLight);

const pointLight = new THREE.PointLight('#ffffff', 3);
pointLight.position.set(1, 2, 2);
scene.add(pointLight);


/**
 * Sizes
 */
const sizes = {
    width: window.innerWidth,
    height: window.innerHeight
}

window.addEventListener('resize', () =>
{
    // Update sizes
    sizes.width = window.innerWidth
    sizes.height = window.innerHeight

    // Update camera
    camera.aspect = sizes.width / sizes.height
    camera.updateProjectionMatrix()

    // Update renderer
    renderer.setSize(sizes.width, sizes.height)
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
})



/**
 * Camera
 */
// Group
const cameraGroup = new THREE.Group();
scene.add(cameraGroup);

// Base camera
const camera = new THREE.PerspectiveCamera(35, sizes.width / sizes.height, 0.1, 100)
camera.position.z = 6
cameraGroup.add(camera);



/**
 * Renderer
 */
const renderer = new THREE.WebGLRenderer({
    canvas: canvas,
    alpha: true, // make canvas transparent
})
renderer.setSize(sizes.width, sizes.height)
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))



/**
 * Scroll
 */
let scrollY = window.scrollY;
let currentSection = 0;

window.addEventListener("scroll", () => {
    scrollY = window.scrollY;
    // console.log("scroll: ", scrollY);

    const newSection = Math.round(scrollY / sizes.height); // it's full number when we arrive at section
    if(newSection != currentSection) {
        currentSection = newSection;
        console.log('changed section', currentSection);

        // tween
        gsap.to(
            sectionMeshes[currentSection].rotation,
            {
                duration: 1.5,
                ease: 'power2.inOut',
                x: "+=6",
                y: "+=3",
                z: "+=1.5"
            }
        )

        // if (currentSection === 0){
        // // tween
        //     gsap.to(
        //         textRotation,
        //         {
        //             duration: 0.5,
        //             ease: 'power2.inOut',
        //             x: "+=3",
        //             // y: "-=3",
        //         }
        //     )
        // }
    }
})


/**
 * Cursor
 */
const cursor = {
    x: 0,
    y: 0,
}

window.addEventListener("mousemove", (event) => {
    cursor.x = event.clientX / sizes.width - 0.5; // vw - makes it same for all resolutions
    cursor.y = event.clientY / sizes.height - 0.5; // vh - makes it same for all resolutions
})

/**
 * Animate
 */
const clock = new THREE.Clock()
let previousTime= 0;

const tick = () =>
{
    const elapsedTime = clock.getElapsedTime()
    const deltaTime = elapsedTime - previousTime;
    previousTime = elapsedTime; // make sure it works the same for different screen fq

    // Animate camera
    camera.position.y = - scrollY / sizes.height * objectsDistance; // sizes.height = vh

    const parallaxX = cursor.x * 0.5;
    const parallaxY = -cursor.y * 0.5;
    cameraGroup.position.x += (parallaxX - cameraGroup.position.x) * 5 * deltaTime; // easing
    cameraGroup.position.y += (parallaxY - cameraGroup.position.y) * 5 * deltaTime;


    // Animate meshes
    for(const mesh of sectionMeshes) {
        mesh.rotation.x += deltaTime * 0.1;
        mesh.rotation.y += deltaTime * 0.12;
    }

    if (text) {
        textRotation.x -= deltaTime * 0.08;
        text.rotation.x = textRotation.x;
    }

    // Render
    renderer.render(scene, camera)

    // Call tick again on the next frame
    window.requestAnimationFrame(tick)


    if (scene.getObjectByName("logo") && sectionMeshes.length === 2) {
        sectionMeshes.unshift(model);
    }
}

tick()