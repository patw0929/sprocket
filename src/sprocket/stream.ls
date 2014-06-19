require! {
  util
  path
  stream
}

const {Transform, PassThrough} = stream

module.exports = SprocketStream
/*
 * SprocketStream
 */
util.inherits SprocketStream, Transform
!function SprocketStream (options)
  return new SprocketStream (options) unless @ instanceof SprocketStream
  options ||= {}
  options.objectMode = true
  #
  Transform.call @, options
  #
  @_endWhenStablize = Transform::end.bind @
  @_endCalled = false
  @_emitErrorInternal = @emit.bind @, 'error'
  #
  @_environment = options.environment
  @_nodeCollection = options.collection
  @_nodeCollection.updateVersion!
  @_dispatchStream = createInternalStreams @, options.extname, options.extensions || {}

SprocketStream::<<<{
  _transform: !(file, _, done) ->
    @_environment.addBasePath file.base
    @_nodeCollection.createNode file, @_emitErrorInternal
    @_dispatchStream.write file
    done!

  # this stream will end some day, but not by default
  end: !->
    @_endCalled = true
    @_end!

  _end: !->
    return unless @_endCalled and @_nodeCollection.isStable
    return @_emitErrorInternal '[SprocketStream] Already ended' unless @_endWhenStablize

    process.nextTick @_endWhenStablize
    @_endWhenStablize = void
    @_nodeCollection
      .generateEntries @_environment.isProduction
      .forEach @push, @
}
/*
 * Helpers
 */
function createInternalStreams (stream, targetExtname, extensions)
  const _internalStreams = {}

  const _dispatchStartStream = new Transform objectMode: true
  _dispatchStartStream._transform = !(file, _, done) ->
    _internalStreams[path.extname file.path].write file
    done!

  const _targetEndStream = new Transform objectMode: true
  _targetEndStream._transform = !(file, _, done) ->
    stream._nodeCollection.finalizeNode file, stream._emitErrorInternal
    stream._end!
    done!

  for extname, configureFn of extensions
    const passThrough = new PassThrough objectMode: true
    _internalStreams[".#{ extname }"] = passThrough

    configureFn stream._environment, passThrough, do
      if extname is targetExtname then _targetEndStream
      else _dispatchStartStream

  _dispatchStartStream
