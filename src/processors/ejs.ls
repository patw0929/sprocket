module.exports = !(environment, src, dest) ->
  require! {
    'gulp-ejs'
  }

  src.pipe gulp-ejs environment.viewLocals, ext: ''
  .pipe dest
