module.exports = !(environment, src, dest) ->
  require! {
    'gulp-jshint'
    'gulp-filter'
    'gulp-uglify'
  }

  const filter = gulp-filter  <[ **/*.js !**/*.min.js ]>
  src.=pipe filter
  .pipe gulp-jshint!
  .pipe gulp-jshint.reporter('default')
  #
  src.=pipe gulp-uglify! if environment.isProduction
  src.=pipe filter.restore!
  #
  src.pipe dest
