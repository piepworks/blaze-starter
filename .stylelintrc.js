module.exports = {
  extends: 'stylelint-config-standard',
  rules: {
    'declaration-empty-line-before': 'never',
    'no-descending-specificity': null,
    'media-feature-range-notation': null,
    'comment-empty-line-before': null,
    'selector-id-pattern': '^[a-z][a-z0-9]*([_|-][a-z0-9]+)*$', // Snake, kebab cases
    'value-keyword-case': null,
    'at-rule-descriptor-no-unknown': null,
  },
  ignoreFiles: ['static_src/css/vendor/**'],
};
