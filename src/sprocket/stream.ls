require! {
  util
  path
  stream
}
require! {
  VinylNodeCollection: '../vinyl_node_collection'
}

const {Transform} = stream

module.exports = SprocketStream
/*
 * SprocketStream
 */
util.inherits SprocketStream, Transform
!function SprocketStream (options)
  return new SprocketStream (options) unless @ instanceof SprocketStream
  options ||= {}
  options.objectMode = true

  Transform.call @, options

  @_endWhenStablize = Transform::end.bind @
  @_endCalled = false
  @_nodeCollection = new VinylNodeCollection!
  @_emitErrorInternal = @emit.bind @, 'error'
  createInternalStreams @, options.extname, options.extensions || {}

SprocketStream::<<<{
  _dispatchInternal: !(file) ->
    @_internalStreams[path.extname file.path].write file

  _transform: !(file, _, done) ->
    @_nodeCollection.createNode file, @_emitErrorInternal
    @_dispatchInternal file
    done!

  # this stream will end some day, but not by default
  end: !->
    @_endCalled = true
    @_end!

  _end: !->
    return unless @_endCalled and @_nodeCollection.isStable!
    return @_emitErrorInternal '[SprocketStream] Already ended' unless @_endWhenStablize
    
    process.nextTick @_endWhenStablize
    @_endWhenStablize = void
    @_nodeCollection.generateEntries!forEach @push, @
}
/*
 * Helpers
 */
function createInternalStreams (stream, targetExtname, extensions)
  const _internalStreams = stream._internalStreams = {}

  const _dispatchEndStream = new Transform objectMode: true
  _dispatchEndStream._transform = !(file, _, done) ->
    stream._nodeCollection.updateNode file, stream._emitErrorInternal
    stream._dispatchInternal file
    done!

  const _targetEndStream = new Transform objectMode: true
  _targetEndStream._transform = !(file, _, done) ->
    stream._nodeCollection.finalizeNode file, stream._emitErrorInternal
    stream._end!
    done!

  for extname, configureFn of extensions
    _internalStreams[".#{ extname }"] = configureFn do
      if extname is targetExtname then _targetEndStream
      else _dispatchEndStream
