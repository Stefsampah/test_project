module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  safelist: [
    'grid-cols-2',
    'grid-cols-3',
    'gap-3',
    'gap-4',
    'grid',
    'grid-template-columns',
    'grid-template-rows'
  ],
  theme: {
    extend: {},
  },
  plugins: [],
} 