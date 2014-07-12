module.exports = (keyPath) ->
  const error = Error """
#{ keyPath } must contain at least one sprocket directive.
If it requires no extra dependency, just put a `require_self` directive.
See https://github.com/tomchentw/sprocket/issues/11
for more details.
  """
  error <<< {keyPath}
  error
