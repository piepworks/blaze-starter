module.exports = {
  extends: 'stylelint-config-standard',
  rules: {
    'declaration-empty-line-before': 'never',
    'no-descending-specificity': null,
  },
  ignoreFiles: ['static_src/css/vendor/**'],
};
