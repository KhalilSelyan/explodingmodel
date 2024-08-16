<script lang="ts">
	import { T, useLoader } from '@threlte/core';
	import { Align, OrbitControls } from '@threlte/extras';
	import {
		BufferAttribute,
		BufferGeometry,
		Color,
		Mesh,
		ShaderMaterial,
		Vector2,
		Vector3
	} from 'three';
	import { OBJLoader } from 'three/examples/jsm/loaders/OBJLoader.js';
	import fragmentShader from './frag.glsl?raw';
	import vertexShader from './vertex.glsl?raw';

	let inputEl: Mesh | undefined;

	const obj = useLoader(OBJLoader).load('/models/hand.obj');

	let geometry: BufferGeometry | undefined;
	obj.then((value) => {
		value.traverse((child) => {
			if (child instanceof Mesh) {
				geometry = child.geometry;
			}
		});
	});

	const color = new Color();
	$: if (geometry) {
		const numFaces = geometry.attributes.position.count / 3;
		const colors = new Float32Array(numFaces * 3 * 3);

		const displacement = new Float32Array(numFaces * 3 * 3);

		for (let f = 0; f < numFaces; f++) {
			const index = 9 * f;
			let lightness = 0.3 + Math.random() * 0.7;
			color.setHSL(0.75, 1.0, lightness);
			let d = 10 * (0.5 * Math.random());

			for (let i = 0; i < 3; i++) {
				colors[index + 3 * i] = color.r;
				colors[index + 3 * i + 1] = color.g;
				colors[index + 3 * i + 2] = color.b;

				displacement[index + 3 * i] = d;
				displacement[index + 3 * i + 1] = d;
				displacement[index + 3 * i + 2] = d;
			}
		}

		geometry.setAttribute('color', new BufferAttribute(colors, 3));
		geometry.setAttribute('displacement', new BufferAttribute(displacement, 3));

		window.addEventListener('mousemove', (e) => {
			const { clientX, clientY } = e;
			const { innerWidth, innerHeight } = window;
			const x = (clientX / innerWidth) * 2 - 1;
			const y = -(clientY / innerHeight) * 2 + 1;
			if (inputEl && inputEl.material instanceof ShaderMaterial) {
				// only if y is greater than 0
				inputEl.material.uniforms.mousePosition.value.set(x, y);
			}
		});
	}
</script>

<T.PerspectiveCamera makeDefault position={[-10, 10, 10]} fov={15}>
	<OrbitControls enableDamping autoRotateSpeed={0.5} />
</T.PerspectiveCamera>

<T.DirectionalLight intensity={1.8} position.x={5} position.y={10} />
<T.AmbientLight intensity={1} />

<Align auto>
	{#if geometry}
		<T.Mesh bind:ref={inputEl} scale={1} {geometry} position={[0, 0, 0]} castShadow receiveShadow>
			<T.ShaderMaterial
				uniforms={{
					mousePosition: { value: new Vector2(0.0, 0.0) },
					lightPosition: { value: new Vector3(5.0, -10.0, -10.0) }
				}}
				{vertexShader}
				{fragmentShader}
			/>
		</T.Mesh>
	{/if}
</Align>
