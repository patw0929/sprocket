require! {
  'gulp-ejs'
}

module.exports = !(environment, src, dest) ->
  src.pipe gulp-ejs environment.viewLocals
  .pipe dest