require! {
  'gulp-sass'
  'gulp-rename'
}

module.exports = (dest) ->
  const options = do
    includePaths: <[
      bower_components/twbs-bootstrap-sass/vendor/assets/stylesheets
    ]>
    outputStyle: 'compressed'
  gulp-sass options
    ..pipe gulp-rename extname: '.min.css'
    .pipe dest
