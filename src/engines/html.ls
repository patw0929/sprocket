require! {
  'gulp-htmlhint'
  'gulp-minify-html'
}

module.exports = !(environment, src, dest) ->
  src.=pipe gulp-htmlhint!
  .pipe gulp-htmlhint.reporter!
  #
  if environment.isProduction
    src.=pipe gulp-minify-html comments: true, spare: true
  #
  src.pipe dest
