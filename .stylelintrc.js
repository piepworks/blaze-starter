module.exports = {
  'extends': 'stylelint-config-standard',
  'rules': {
    'indentation': 2,
    'string-quotes': 'single',
    'declaration-empty-line-before': 'never',
    'no-descending-specificity': null,
  },
  'ignoreFiles': ['static/css/vendor/**'],
};
