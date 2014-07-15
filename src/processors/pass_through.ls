module.exports = class PassThrough

  !(@_environment, @_collection, @_stream) ->

  process: !->
    @_collection.vinyls.forEach @_stream.push, @_stream
