// Vite config for the HBuilderX-created uni-app (Vue3) project.
//
// Purpose: copy the WeChat cloud functions folder into the compiled output so
// that "cloudfunctionRoot": "cloudfunctions/" (manifest.json -> mp-weixin)
// resolves to a real directory inside the project imported by WeChat DevTools.
// uni-app does NOT copy it automatically.
//
// Note: this project has no package.json / node_modules (pure HBuilderX
// project), so this config intentionally does NOT import @dcloudio/vite-plugin-uni
// -- HBuilderX injects the uni plugin itself. Only the copy plugin lives here.

const fs = require('fs');
const path = require('path');

function resolveOutRoot() {
  // Prefer the env var the uni-app compiler sets (dev and build both set it).
  if (process.env.UNI_OUTPUT_DIR) return process.env.UNI_OUTPUT_DIR;
  const isProd = process.env.NODE_ENV === 'production';
  return path.join(__dirname, 'unpackage', 'dist', isProd ? 'build' : 'dev', 'mp-weixin');
}

function copyCloudFunctions() {
  if (process.env.UNI_PLATFORM && process.env.UNI_PLATFORM !== 'mp-weixin') return;
  const src = path.join(__dirname, 'cloudfunctions');
  if (!fs.existsSync(src)) return;
  const dest = path.join(resolveOutRoot(), 'cloudfunctions');
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  fs.cpSync(src, dest, { recursive: true });
  console.log('[copy-cloudfunctions] ' + src + ' -> ' + dest);
}

// Copy once when the config loads and again at build start (covers dev & build).
copyCloudFunctions();

module.exports = {
  plugins: [
    {
      name: 'copy-cloudfunctions',
      buildStart() {
        copyCloudFunctions();
      }
    }
  ]
};
