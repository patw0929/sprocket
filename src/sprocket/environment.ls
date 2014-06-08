require! {
  path
}
require! {
  SupportedExtname: './helpers/supported_extname'
}

const SupportedExtnames = [
  
  new SupportedExtname 'javascripts' 'js' <[ ls ]>

  new SupportedExtname 'stylesheets' 'css' <[ scss ]>
]

SprocketEnvironment <<< {SupportedExtnames}

module.exports = SprocketEnvironment
/*
 * SprocketEnvironment
 */
!function SprocketEnvironment (options || {})
  @basePath = options.basePath || 'tmp/public'
  @javascriptsRelativePath = options.javascriptsRelativePath || 'assets'
  @stylesheetsRelativePath = options.stylesheetsRelativePath || 'assets'

const {prototype} = SprocketEnvironment

prototype<<< {
  javascriptsPath:~
    -> path.join @basePath, @javascriptsRelativePath

  stylesheetsPath:~
    -> path.join @basePath, @stylesheetsRelativePath
}

SupportedExtnames.forEach !({title, extname}) ->
  prototype["#{ title }ManifestPath"] = (keyPath) ->
    mainfestPath @["#{ title }Path"], keyPath, extname
/*
 * Helpers
 */
function mainfestPath (basePath, keyPath, extname)
  path.join do
    basePath
    path.dirname keyPath
    "#{ path.basename(keyPath) }.#{ extname }.manifest.json"
