require! {
  'gulp-less'
}

module.exports = !(environment, src, dest) ->
  const options = do
    paths: environment.basePaths
    compress: environment.isProduction
  src.pipe gulp-less options
  .pipe dest
