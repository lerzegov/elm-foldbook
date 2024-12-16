import resolve from 'rollup-plugin-node-resolve';
import commonjs from 'rollup-plugin-commonjs';
import { terser } from 'rollup-plugin-terser';
import elm from 'rollup-plugin-elm';
import copy from 'rollup-plugin-copy'; // Copy fonts
import typescript from '@rollup/plugin-typescript';

export default {
  input: 'srcjs/mathlive-element.ts', // Entry point is now TypeScript
  output: {
    file: 'dist/mathlive-bundle.js',
    format: 'iife',
    name: 'MyApp',
    sourcemap: true,
  },
  plugins: [
    resolve({
      extensions: ['.mjs', '.js', '.ts'], // Ensure it resolves .mjs files
    }),
    commonjs(),
    elm({
      exclude: 'elm-stuff/**',
      optimize: true,
    }),
    typescript(),
    terser(),
    copy({
      targets: [
        { src: 'node_modules/mathlive/dist/fonts/**/*', 
          dest: 'dist/fonts' 
        },
        { src: 'node_modules/mathlive/dist/sounds/**/*', 
          dest: 'dist/sounds' 
        },
        {
          src: 'node_modules/speech-rule-engine/lib/mathmaps/**/*',
          dest: 'dist/mathmaps',
        },
      ],
    }),
  ],
};
