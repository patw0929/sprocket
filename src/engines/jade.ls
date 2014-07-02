module.exports = !(environment, src, dest) ->
  require! {
    'gulp-jade'
  }

  const options = do
    pretty: !environment.isProduction,
    locals: environment.viewLocals
  src.pipe gulp-jade options
  .pipe dest
