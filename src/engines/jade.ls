module.exports = !(environment, src, dest) ->
  require! {
    'gulp-jade'
  }

  const options = do
    pretty: !environment.minifyHTML,
    locals: environment.viewLocals
  src.pipe gulp-jade options
  .pipe dest
