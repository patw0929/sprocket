require! {
  'gulp-filter'
  'gulp-minify-css'
  'gulp-rename'
}

module.exports = !(environment, src, dest) ->
  if environment.isProduction
    const filter = gulp-filter '!**/*.min.css'
    src.=pipe filter
    .pipe gulp-minify-css!
    .pipe gulp-rename extname: '.min.css'
    .pipe filter.restore!
  #
  src.pipe dest
