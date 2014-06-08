require! {
  'gulp-filter'
  'gulp-uglify'
  'gulp-rename'
}

module.exports = !(environment, src, dest) ->
  if environment.isProduction
    const filter = gulp-filter '!**/*.min.js'
    src.=pipe filter
    .pipe gulp-uglify!
    .pipe gulp-rename extname: '.min.js'
    .pipe filter.restore!
  #
  src.pipe dest
