module.exports = class PassThrough

  !(@_environment, @collection, @stream) ->

  process: !->
    @collection.vinyls.forEach @stream.push, @stream
