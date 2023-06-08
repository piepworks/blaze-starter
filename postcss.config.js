module.exports = {
  plugins: {
    'postcss-import': {},
    'postcss-nested': {},
    autoprefixer: {},
    ...(process.env.NODE_ENV === 'production' ? { cssnano: {} } : {}),
  },
};
