require! {
  SprocketStream: './stream'
  SprocketEnvironment: './environment'
  SprocketGulpHelper: './helpers/gulp'
  SprocketViewHelper: './helpers/view'
}

module.exports = Sprocket
Sprocket.Stream = SprocketStream

const {SupportedExtnames} = SprocketEnvironment

!function Sprocket (@options || {})
  @environment = new SprocketEnvironment @options.environment || {}

  SupportedExtnames.forEach !(se) ->
    @["_#{ se.title }"] = se.createStream!
  , @

  @gulp = new SprocketGulpHelper @environment, @options.gulp
  @view = new SprocketViewHelper @environment, @options.view

const {prototype} = Sprocket

SupportedExtnames.forEach !(se) ->
  Object.defineProperty prototype, se.title, do
    get: -> @["_#{ se.title }"]
