require! {
  'gulp-livescript'
}

module.exports = !(environment, src, dest) ->
  src.pipe gulp-livescript!
  .pipe dest
