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
  @_stream_has_ended = false
  #
  {@mimeType} = options
  @_environment = options.environment
  @_collection = options.collection
  @_dispatch_start_stream = options.dispatchStartStream


SprocketsTransform::<<< {
  _transform: !(file, enc, done) ->
    if file.isDirectory!
      @_environment.add_base_path file.path
    else
      @_environment.add_base_path file.base
      @_dispatch_start_stream.write file if @_collection.createNode file, @
    done!

  end: !->
    @_stream_has_ended = true
    @_endEventually!

  _endEventually: !->
    return unless @_stream_has_ended and @_collection.isStable
    return @emit 'error', 'Stream already ended!' unless @_bounded_end_fn

    process.nextTick @_bounded_end_fn
    @_bounded_end_fn = void
    #
    @_environment.end_stream @
    @_environment = @_collection = @_dispatch_start_stream = void
}
