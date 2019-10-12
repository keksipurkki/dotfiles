module.exports = {
  parser: 'espree',
  extends: ['eslint:recommended'],
  parserOptions: {
    ecmaVersion: 2018,
    sourceType: 'script',
  },
  env: {
    node: true
  },
  rules: {
    semi: 2
  },
};
