module.exports = {
  plugins: {
    'postcss-import': {},
    'postcss-nesting': {},
    autoprefixer: {},
    ...(process.env.NODE_ENV === 'production' ? { cssnano: {} } : {}),
  },
};
