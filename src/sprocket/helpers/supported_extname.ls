require! {
  SprocketStream: '../stream'
}

module.exports = SupportedExtname

!function SupportedExtname (@title, @extname, @extensionNames)
  void

SupportedExtname::createStream = (environment) ->
  new SprocketStream do
    environment: environment
    extname: @extname
    extensions: @extensionNames.reduce (object, extension) ->
      object[extension] = require("../ext/#{ extension }")
      object
    , {"#{ @extname }": require("../ext/#{ @extname }") }
