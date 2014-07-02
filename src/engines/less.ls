module.exports = !(environment, src, dest) ->
  require! {
    'gulp-less'
  }

  const options = do
    paths: environment.basePaths
    compress: environment.isProduction
  src.pipe gulp-less options
  .pipe dest
