require! {
  'gulp-sass'
  'gulp-rename'
}

module.exports = !(environment, src, dest) ->
  const options = do
    includePaths: <[
      bower_components/twbs-bootstrap-sass/vendor/assets/stylesheets
    ]>
    outputStyle: if environment.isProduction then 'compressed' else 'nested'
  src.=pipe gulp-sass options
  if environment.isProduction
    src.=pipe gulp-rename extname: '.min.css'
  #
  src.pipe dest
