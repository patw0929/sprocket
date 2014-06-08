require! {
  SprocketStream: '../stream'
}

module.exports = SupportedExtname

!function SupportedExtname (@title, @extname, @extensionNames)
  void

SupportedExtname::createStream = -> new SprocketStream do
  extname: @extname
  extensions: @extensionNames.reduce (object, extension) ->
    object[extension] = require("../ext/#{ extension }")
    object
  , {"#{ @extname }": require("../ext/#{ @extname }") }
