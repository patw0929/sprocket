module.exports = !(environment, src, dest) ->
  require! {
    'gulp-filter'
    'gulp-minify-css'
  }

  if environment.minifyCSS
    const filter = gulp-filter <[ **/*.css !**/*.min.css ]>
    src.=pipe filter
    .pipe gulp-minify-css!
    .pipe filter.restore!
  #
  src.pipe dest
