require! {
  util
  Stream: 'stream'
}

module.exports = SprocketsTransform

const {Transform} = Stream
util.inherits SprocketsTransform, Transform

!function SprocketsTransform (arg)
  return new SprocketsTransform(arg) unless @ instanceof SprocketsTransform
  const options = &0 ||= {}
  options.objectMode = true
  Transform ...
  #
  @_boundedEndFn = Transform::end.bind @
  @_streamEnded = false
  #
  {@mimeType} = options
  @_environment = options.environment
  @_collection = options.collection
  @_dispatchStartStream = options.dispatchStartStream


SprocketsTransform::<<< {
  _transform: !(file, enc, done) ->
    @_environment._addBasePath file.base
    if @_collection.createNode file, @
      @_dispatchStartStream.write file
    else
      @_collection.finalizeNode file, @
    done!

  end: !->
    @_streamEnded = true
    @_endEventually!

  _endEventually: !->
    return unless @_streamEnded and @_collection.isStable
    return @emit 'error', 'Stream already ended!' unless @_boundedEndFn

    process.nextTick @_boundedEndFn
    @_boundedEndFn = void
    #
    @_environment._endStream @
    @_environment = @_collection = @_dispatchStartStream = void
}
