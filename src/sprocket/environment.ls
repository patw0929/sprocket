require! {
  path
  nconf
}
require! {
  SupportedExtname: './helpers/supported_extname'
  RequireState: '../vinyl_node_collection/require_state'
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
!function SprocketEnvironment (options)
  [@[key] = val for key, val of options || {}]
/*
 * SprocketEnvironment.prototype
 */
const {prototype} = SprocketEnvironment

prototype<<< {
  isProduction:~
    -> 'production' is nconf.get 'NODE_ENV'

  javascriptsPath:~
    -> path.join @basePath, @javascriptsRelativePath

  stylesheetsPath:~
    -> path.join @basePath, @stylesheetsRelativePath
}

SupportedExtnames.forEach !({title, extname}) ->
  prototype["#{ title }ManifestPath"] = (keyPath) ->
    const baseAndExtnames = RequireState.keyPath2BaseAndExtnames {
      keyPath
      isProduction: @isProduction
      extname: ".#{ extname }#{ RequireState.MANIFEST_EXTNAME }"
    }
    path.join @["#{ title }Path"], baseAndExtnames.join('')
