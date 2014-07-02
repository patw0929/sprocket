module.exports = !(environment, src, dest) ->
  require! {
    'gulp-livescript'
  }

  src.pipe gulp-livescript!
  .pipe dest
