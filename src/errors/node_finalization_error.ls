module.exports = (keyPath, filepath) ->
  const error = Error """
Can't finalize node #{ keyPath } from file (#{ filepath }).
  """
  error <<< {keyPath, filepath}
  error
