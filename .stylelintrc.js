module.exports = {
  'extends': 'stylelint-config-standard',
  'rules': {
    'indentation': 2,
    'string-quotes': 'single',
    'declaration-empty-line-before': 'never',
    'no-descending-specificity': null,
    // Tailwind-related rules:
    // -----------------------
    'function-no-unknown': [
      true,
      { ignoreFunctions: ['theme'] }
    ],
    'at-rule-no-unknown': [
      true,
      {
        ignoreAtRules: [
          'tailwind',
          'apply',
          'variants',
          'responsive',
          'screen',
        ]
      }
    ],
    'at-rule-empty-line-before': null,
    'value-keyword-case': null,
    'number-leading-zero': null,
    'number-no-trailing-zeros': null,
    // -----------------------
  },
  'ignoreFiles': ['static/tailwind.css'],
};
