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
  @_bounded_end_fn = Transform::end.bind @
  @_streamEnded = false
  #
  {@mimeType} = options
  @_environment = options.environment
  @_collection = options.collection
  @_dispatchStartStream = options.dispatchStartStream


SprocketsTransform::<<< {
  _transform: !(file, enc, done) ->
    if file.isDirectory!
      @_environment.add_base_path file.path
    else
      @_environment.add_base_path file.base
      @_dispatchStartStream.write file if @_collection.createNode file, @
    done!

  end: !->
    @_streamEnded = true
    @_endEventually!

  _endEventually: !->
    return unless @_streamEnded and @_collection.isStable
    return @emit 'error', 'Stream already ended!' unless @_bounded_end_fn

    process.nextTick @_bounded_end_fn
    @_bounded_end_fn = void
    #
    @_environment.end_stream @
    @_environment = @_collection = @_dispatchStartStream = void
}
