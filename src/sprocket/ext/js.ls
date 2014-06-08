require! {
  'gulp-jshint'
  'gulp-filter'
  'gulp-uglify'
  'gulp-rename'
}

module.exports = !(environment, src, dest) ->
  const filter = gulp-filter '!**/*.min.js'
  src.=pipe filter
  .pipe gulp-jshint!
  .pipe gulp-jshint.reporter('default')
  #
  if environment.isProduction
    src.=pipe gulp-uglify!
    .pipe gulp-rename extname: '.min.js'
  src.=pipe filter.restore!
  #
  src.pipe dest
