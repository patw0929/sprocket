require! {
  nconf
}

require! {
  SprocketStream: './stream'
  SprocketCollection: './vinyl_node'
  SprocketEnvironment: './environment'
  SprocketGulpHelper: './helpers/gulp'
  SprocketViewHelper: './helpers/view'
}

module.exports = CoC
CoC <<< {Sprocket}
CoC.Sprocket.Stream = SprocketStream
/*
 * Convention over Configuration
 */
function CoC
  nconf.env!argv!.defaults do
    NODE_ENV: 'development'

  new Sprocket do
    environment: do
      basePath: 'tmp/public'
      javascriptsRelativePath: 'assets'
      stylesheetsRelativePath: 'assets'
  #
  .registerHandler 'javascripts' <[ ls ]> require('./ext/ls')
  .registerHandler 'javascripts' <[ js ]> require('./ext/js')
  #
  .registerHandler 'stylesheets' <[ scss sass ]> require('./ext/scss')
  .registerHandler 'stylesheets' <[ css ]> require('./ext/css')
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

    extnames.forEach !(extension) -> @[extension] = handler
    , @["_#{ ancestor }Extensions"]
    @

  createStream: (ancestor) ->
    unless ancestor of SUPPORTED_ANCESTORS
      throw "Currently we only support #{ SUPPORTED_ANCESTORS.join ',' }"

    new SprocketStream do
      environment: @environment
      collection: @_nodeCollections[ancestor] ||= new SprocketCollection!
      extname: SUPPORTED_ANCESTORS[ancestor]
      extensions: @["_#{ ancestor }Extensions"]
}
