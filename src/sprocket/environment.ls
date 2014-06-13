require! {
  path
  nconf
}
require! {
  SprocketRequireState: './vinyl_node/require_state'
}

const SUPPORTED_ANCESTORS = {
  javascripts: 'js'
  stylesheets: 'css'
}

SprocketEnvironment <<< {SUPPORTED_ANCESTORS}

module.exports = SprocketEnvironment
/*
 * SprocketEnvironment
 */
!function SprocketEnvironment (options)
  [@[key] = val for key, val of options || {}]
  @_basePaths = []
/*
 * SprocketEnvironment.prototype
 */
const {prototype} = SprocketEnvironment

prototype<<< {
  isProduction:~
    -> 'production' is nconf.get 'NODE_ENV'

  basePaths:~
    #
    # HACK: 
    # returns a direct reference for gulp-sass.options.includePaths
    # since it is lazy evaluated during transforming state
    #
    -> @_basePaths

  addBasePath: ->
    const {_basePaths} = @
    [return false for basePath in _basePaths when basePath is it]
    !!_basePaths.push it
}

Object.keys SUPPORTED_ANCESTORS .forEach !(ancestor) ->
  Object.defineProperty prototype, "#{ ancestor }Path", do
    get: -> path.join @basePath, @["#{ ancestor }RelativePath"]

  const extname = SUPPORTED_ANCESTORS[ancestor]

  prototype["#{ ancestor }ManifestPath"] = (keyPath) ->
    const baseAndExtnames = SprocketRequireState.keyPath2BaseAndExtnames {
      keyPath
      isProduction: @isProduction
      extname: ".#{ extname }#{ SprocketRequireState.MANIFEST_EXTNAME }"
    }
    path.join @["#{ ancestor }Path"], baseAndExtnames.join('')
