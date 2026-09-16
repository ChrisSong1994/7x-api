import { defineConfig, loadEnv } from 'vite'
import react from '@vitejs/plugin-react'
import { tanstackRouter } from '@tanstack/router-plugin/vite'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = path.dirname(fileURLToPath(import.meta.url))

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), 'VITE_')
  const serverUrl =
    process.env.VITE_REACT_APP_SERVER_URL ||
    env.VITE_REACT_APP_SERVER_URL ||
    'http://localhost:3000'

  const isProd = mode === 'production'
  const devProxy = Object.fromEntries(
    (['/api', '/mj', '/pg'] as const).map((key) => [
      key,
      { target: serverUrl, changeOrigin: true },
    ])
  ) as Record<string, { target: string; changeOrigin: boolean }>

  return {
    plugins: [
      // Must be placed before the React plugin.
      tanstackRouter({
        target: 'react',
        // Dev: avoid per-route async chunks (reduces white flash on navigation + faster HMR feedback).
        // Prod: keep route-based code splitting.
        autoCodeSplitting: isProd,
      }),
      react(),
    ],
    resolve: {
      alias: {
        '@': path.resolve(__dirname, './src'),
      },
    },
    server: {
      host: '0.0.0.0',
      port: 3001,
      proxy: devProxy,
    },
    build: {
      outDir: 'dist',
      rolldownOptions: {
        // Remove `console.log` in production (keep console.warn / console.error).
        treeshake: isProd
          ? { manualPureFunctions: ['console.log'] }
          : undefined,
        output: {
          // Vite 8 (Rolldown): replaces `manualChunks` / Rsbuild `splitChunks`.
          codeSplitting: {
            groups: [
              {
                name: 'vendor-react',
                test: /node_modules[\\/](react|react-dom)[\\/]/,
              },
              {
                name: 'vendor-radix',
                test: /node_modules[\\/]@radix-ui[\\/]/,
              },
              {
                name: 'vendor-tanstack',
                test: /node_modules[\\/]@tanstack[\\/]/,
              },
            ],
          },
          // Preserve third-party legal comments (inline) in all modes.
          // Do not strip them: minifier-preserved third-party notices are required for
          // open-source license compliance in some distributions.
          comments: { legal: true },
        },
      },
    },
  }
})
