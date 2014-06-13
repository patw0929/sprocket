require! {
  SprocketStream: './stream'
  SprocketCollection: './vinyl_node'
  SprocketEnvironment: './environment'
  SprocketGulpHelper: './helpers/gulp'
  SprocketViewHelper: './helpers/view'
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

  @gulp = new SprocketGulpHelper @environment, @options.gulp
  @view = new SprocketViewHelper @environment, @options.view
/*
 * Sprocket.prototype
 */
const {prototype} = Sprocket

const {SUPPORTED_ANCESTORS} = SprocketEnvironment

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
}
