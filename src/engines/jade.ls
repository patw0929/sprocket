require! {
  'gulp-jade'
}

module.exports = !(environment, src, dest) ->
  const options = do
    pretty: !environment.isProduction,
    locals: environment.viewLocals
  src.pipe gulp-jade options
  .pipe dest
