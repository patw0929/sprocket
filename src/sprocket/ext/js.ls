require! {
  'gulp-filter'
  'gulp-uglify'
  'gulp-rename'
}

module.exports = (dest) ->
  const filter = gulp-filter '!**/*.min.js'
  filter.pipe gulp-uglify!
    .pipe gulp-rename extname: '.min.js'
    .pipe filter.restore!
    .pipe dest
  filter
