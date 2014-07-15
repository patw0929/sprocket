module.exports = class PassThrough

  !(@_environment, @_collection, @stream) ->

  process: !->
    @_collection.vinyls.forEach @stream.push, @stream
