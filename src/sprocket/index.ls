require! {
  nconf
}

require! {
  SprocketStream: './stream'
  SprocketEnvironment: './environment'
  SprocketGulpHelper: './helpers/gulp'
  SprocketViewHelper: './helpers/view'
}

module.exports = Sprocket
Sprocket.Stream = SprocketStream
Sprocket.CoC = CoC
/*
 * Convention over Configuration
 */
function CoC
  nconf.defaults do
    NODE_ENV: 'development'

  new Sprocket do
    environment: do
      basePath: 'tmp/public'
      javascriptsRelativePath: 'assets'
      stylesheetsRelativePath: 'assets'
/*
 * Sprocket
 */
const {SupportedExtnames} = SprocketEnvironment

!function Sprocket (@options || {})
  @environment = new SprocketEnvironment @options.environment

  SupportedExtnames.forEach !(se) ->
    @["_#{ se.title }"] = se.createStream!
  , @

  @gulp = new SprocketGulpHelper @environment, @options.gulp
  @view = new SprocketViewHelper @environment, @options.view
/*
 * Sprocket.prototype
 */
const {prototype} = Sprocket

SupportedExtnames.forEach !(se) ->
  Object.defineProperty prototype, se.title, do
    get: -> @["_#{ se.title }"]
