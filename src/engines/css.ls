require! {
  'gulp-filter'
  'gulp-minify-css'
}

module.exports = !(environment, src, dest) ->
  if environment.isProduction
    const filter = gulp-filter <[ **/*.css !**/*.min.css ]>
    src.=pipe filter
    .pipe gulp-minify-css!
    .pipe filter.restore!
  #
  src.pipe dest
