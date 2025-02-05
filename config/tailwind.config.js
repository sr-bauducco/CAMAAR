const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms')({
      strategy: 'class',
    }),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ],
  // Configurações globais para formulários
  future: {
    hoverOnlyWhenSupported: true,
  },
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
}

// Adicione ao seu arquivo app/assets/stylesheets/application.tailwind.css
// @layer components {
//   .form-input,
//   .form-select,
//   .form-textarea {
//     @apply py-3 px-4;
//   }
// } 