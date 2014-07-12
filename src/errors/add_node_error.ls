module.exports = (keyPath, message) ->
  message or= "some unknown file error happens."
  const error = Error """
You require #{ keyPath } but #{ message }
Make sure gulp.src did select the file you wants.
  """
  error <<< {keyPath}
  error
