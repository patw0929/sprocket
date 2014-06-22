module.exports = class PassThrough

  !(@environment, @collection, @stream) ->

  process: !->
    @collection.vinyls.forEach @stream.push, @stream
