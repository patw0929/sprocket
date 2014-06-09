require! {
  path
  nconf
}
require! {
  SupportedExtname: './helpers/supported_extname'
  SprocketRequireState: './vinyl_node/require_state'
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
    const baseAndExtnames = SprocketRequireState.keyPath2BaseAndExtnames {
      keyPath
      isProduction: @isProduction
      extname: ".#{ extname }#{ SprocketRequireState.MANIFEST_EXTNAME }"
    }
    path.join @["#{ title }Path"], baseAndExtnames.join('')
