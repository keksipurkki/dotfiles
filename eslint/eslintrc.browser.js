module.exports = {
  parser: "espree",
  extends: ["eslint:recommended"],
  parserOptions: {
    ecmaVersion: 2018,
    sourceType: "module",
  },
  env: {
    browser: true,
  },
  rules: {
    semi: 2
  },
};
