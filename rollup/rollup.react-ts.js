import typescript from "rollup-plugin-typescript2";

const pwa = {
  input: "./src/index.tsx",
  output: {
    file: "./public_html/app.js",
    sourcemap: true,
    format: "iife",
    globals: {
      react: "React",
      "react-dom": "ReactDOM",
      "react-redux": "ReactRedux",
      "redux": "Redux"
    },
  },
  external: ["react", "react-dom", "redux", "react-redux"],
  plugins: [typescript()],
};

export default [pwa];
