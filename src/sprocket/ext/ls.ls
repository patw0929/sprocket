require! {
  'gulp-livescript'
}

module.exports = (dest) ->
  gulp-livescript!
    ..pipe dest
