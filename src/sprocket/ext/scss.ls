require! {
  'gulp-sass'
  'gulp-rename'
}

module.exports = !(environment, src, dest) ->
  const {isProduction} = environment
  const options = do
    includePaths: environment.basePaths
    outputStyle: if isProduction then 'compressed' else 'nested'
  src.=pipe gulp-sass options
  if isProduction
    src.=pipe gulp-rename extname: '.min.css'
  #
  src.pipe dest
