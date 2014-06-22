require! {
  os
  url
}

module.exports = Locals

function Locals (@_environment)
  #
  # We also create underscored version for you
  #
  [@[underscore(name)] = @[name] = fn.bind @ for name, fn of Locals::]
  @

Locals::<<< {
  javascriptIncludeTag: (keyPath, options || {}) ->
    options.assetsPath ||= '/assets/'
    options.indent ||= '  '*2# html->head/body->tag
    #
    @_environment.getManifestFilepaths 'application/javascript', keyPath
    .map createScriptTag, options
    .join os.EOL

  stylesheetLinkTag: (keyPath, options || {}) ->
    options.assetsPath ||= '/assets/'
    options.indent ||= '  '*2# html->head/body->tag
    #
    @_environment.getManifestFilepaths 'text/css', keyPath
    .map createStyleTag, options
    .join os.EOL
}
/*
 * Private APIs
 */
function underscore
  it.replace /([A-Z])/g, underscoreReplacer

function underscoreReplacer
  "_#{ it.toLowerCase! }"

function createScriptTag (it, index)
  "
#{ if 0 is index then os.EOL else '' }#{ @indent }
<script type=\"text/javascript\" src=\"#{
    url.resolve @assetsPath, it }\">
</script>
  "
function createStyleTag (it, index)
  "
#{ if 0 is index then os.EOL else '' }#{ @indent }
<link rel=\"stylesheet\" href=\"#{
    url.resolve @assetsPath, it }\">
  "
