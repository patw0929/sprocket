require! {
  path
}

const TitleExtnameMappings = {javascripts: 'js', stylesheets: 'css'}
SprocketEnvironment <<< {TitleExtnameMappings}

module.exports = SprocketEnvironment
/*
 * SprocketEnvironment
 */
!function SprocketEnvironment (options || {})
  @basePath = options.basePath || 'tmp/public'
  @javascriptsRelativePath = options.javascriptsRelativePath || 'assets'
  @stylesheetsRelativePath = options.stylesheetsRelativePath || 'assets'

const {prototype} = SprocketEnvironment::

prototype<<< {
  javascriptsPath:~
    -> path.join @basePath, @javascriptsRelativePath

  stylesheetsPath:~
    -> path.join @basePath, @stylesheetsRelativePath
}

for title, extname of TitleExtnameMappings
  prototype["#{ title }ManifestPath"] = let title = title, extname = extname
    (keyPath) -> mainfestPath @["#{ title }Path"], keyPath, extname
/*
 * Helpers
 */
function mainfestPath (basePath, keyPath, extname)
  path.join do
    basePath
    path.dirname keyPath
    "#{ path.basename(keyPath) }#{ extname }.manifest.json"
