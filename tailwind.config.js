/** @type {import('tailwindcss').Config} */
const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  content: [
    '**/templates/**/*.{html,js,svg}',
  ],
  theme: {
    extend: {
      // Add stuff as needed.
    },
  },
  plugins: [],
};
