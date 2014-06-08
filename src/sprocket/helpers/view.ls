require! {
  os
  fs
  path
}

module.exports = SprocketViewHelpers
/*
 * SprocketViewHelpers
 */
!function SprocketViewHelpers (@environment, options)
  [@[key] = val for key, val of options || {}]

  for key of SprocketViewHelpers::
    const func = @[key].=bind @# so that we won't lose self in views
    continue unless key.match /Tag$/
    # for rails underscored helpers ?!
    @[key.replace /([A-Z])/g, -> "_#{ it.toLowerCase! }"] = func
  
SprocketViewHelpers::<<< {
  javascriptIncludeTag: (keyPath) ->
    getManifestAsJson @environment.javascriptsManifestPath keyPath
    .map ~> """
<script type=\"text/javascript\" src=\"#{
  path.join @environment.javascriptsRelativePath, it
}\"></script>
            """
    .join os.EOL

  stylesheetLinkTag: (keyPath) ->
    getManifestAsJson @environment.stylesheetsManifestPath keyPath
    .map ~> """
<link rel=\"stylesheet\" href=\"#{
  path.join @environment.stylesheetsRelativePath, it
}\">
            """
    .join os.EOL
}
/*
 * Helpers
 */
function getManifestAsJson (manifestPath)
  JSON.parse fs.readFileSync manifestPath, 'utf8'
