require! {
  os
  url
}
require! {
  SprocketStream: './stream'
  SprocketCollection: './vinyl_node'
  SprocketEnvironment: './environment'
}

module.exports = Sprocket
Sprocket.Stream = SprocketStream
/*
 * Sprocket
 */
!function Sprocket (@options || {})
  @_javascriptsExtensions = {}
  @_stylesheetsExtensions = {}

  @_nodeCollections = {}

  @environment = new SprocketEnvironment @options.environment
/*
 * Sprocket.prototype
 */
const {prototype} = Sprocket

const {SUPPORTED_ANCESTORS} = SprocketEnvironment

Object.keys SUPPORTED_ANCESTORS .forEach !(ancestor) ->
  prototype["create#{ titleize(ancestor) }Stream"] = ->
    @createStream ancestor, ...&

prototype<<< {
  registerHandler: (ancestor, extnames, handler) ->
    unless ancestor of SUPPORTED_ANCESTORS
      throw "Currently we only support #{ SUPPORTED_ANCESTORS.join ',' }"

    @_nodeCollections[ancestor] ||= new SprocketCollection!
    extnames.forEach !(extension) -> @[extension] = handler
    , @["_#{ ancestor }Extensions"]
    @

  createStream: (ancestor) ->
    unless ancestor of SUPPORTED_ANCESTORS
      throw "Currently we only support #{ SUPPORTED_ANCESTORS.join ',' }"

    new SprocketStream do
      environment: @environment
      collection: @_nodeCollections[ancestor]
      extname: SUPPORTED_ANCESTORS[ancestor]
      extensions: @["_#{ ancestor }Extensions"]

  createViewHelpers: (options || {}) ->
    options.assetsPath ||= '/'
    options.indent ||= '  '*2# html->head/body->tag
    #
    Object.keys SUPPORTED_ANCESTORS .reduce (helpers, ancestor) ~>
      ~function helperFn
        getManifestAsJson @, ancestor, it
        .map getManifestAsJson["#{ ancestor }MapFn"], options
        .join os.EOL

      const helperName = getManifestAsJson[ancestor]
      helpers[helperName] = helperFn
      if helperName.match /Tag$/
        # for rails underscored helpers ?!
        helpers[underscore(helperName)] = helperFn
      helpers
    , {}
}

function getManifestAsJson (sprocket, ancestor, keyPath)
  sprocket._nodeCollections[ancestor].getManifestContent do
    keyPath: keyPath
    isProduction: sprocket.environment.isProduction
    extname: ".#{ SUPPORTED_ANCESTORS[ancestor] }"

getManifestAsJson.javascripts = 'javascriptIncludeTag'

getManifestAsJson.javascriptsMapFn = (it, index) ->
  "
#{ if 0 is index then os.EOL else '' }#{ @indent }
<script type=\"text/javascript\" src=\"#{
    url.resolve @assetsPath, it }\">
</script>
  "

getManifestAsJson.stylesheets = 'stylesheetLinkTag'

getManifestAsJson.stylesheetsMapFn = (it, index) ->
  "
#{ if 0 is index then os.EOL else '' }#{ @indent }
<link rel=\"stylesheet\" href=\"#{
    url.resolve @assetsPath, it }\">
  "

function underscore
  it.replace /([A-Z])/g, underscoreReplacer

function underscoreReplacer
  "_#{ it.toLowerCase! }"

function titleize
  "#{ it.charAt 0 .toUpperCase! }#{ it.slice 1 }"

