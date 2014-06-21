require! {
  path
  'stream': Stream
}
require! {
  '../index': Sprockets
  '../vinyl_node': VinylNodeCollection
  './base': Base
}

class Environment extends Base

  (root = '.') ->
    @vinyl_node_collections = {}
    
    
  registerMimeType: !(mime_type) ->
    super ...
    @vinyl_node_collections[mime_type] ||= new VinylNodeCollection!

module.exports =  Environment
# 
# Private APIs
# 
const {Transform, PassThrough} = Stream
Environment::<<< {

  _createStream: (mime_type) ->
    const collection = @vinyl_node_collections[mime_type]
    const targetExtention = @mime_type[mime_type].extensions.0
    #
    # create a engines stream map to to transformation
    #
    const extEngines = {}
    const dispatchStartStream = new Transform objectMode: true
    dispatchStartStream._transform = !(file, enc, done) ->
      extEngines[path.extname file.path].write file
      done!
    #
    # build up all extension engines
    #
    for engineExtension, couldBeTargetExt of @engine_extensions
      continue if couldBeTargetExt isnt targetExtention
      const passThroughStream = new PassThrough objectMode: true

      extEngines[engineExtension] = PassThrough
      @engines[engineExtension](@, PassThrough, dispatchStartStream)
    #
    # link the target extension stream up
    #
    const dispatchEndStream = new Transform objectMode: true
    dispatchEndStream._transform = !(file, enc, done) ->
      collection.finalizeNode file, @
      stream.endEventually!
      done!
   
    extEngines[targetExtention] = new PassThrough objectMode: true
    @engines[targetExtention](@, extEngines[targetExtention], dispatchEndStream)
    #
    # setup stream that we want to return
    #
    const stream = new Transform objectMode: true
    streamEndFn = stream.end.bind stream
    streamEnded = false
    stream.end = !->
      streamEnded := true
      @endEventually!
    #
    # setup callback that would acutally end the stream
    #
    stream.endEventually = !->
      return unless streamEnded and collection.isStable
      return @emit 'error', 'Stream already ended!' unless streamEndFn

      process.nextTick streamEndFn
      streamEndFn := void

      collection.pushEntries stream, @
    #
    # begining receiving files
    #
    const environment = @
    stream._transform = !(file, enc, done) ->
      environment.addBasePath file.base
      collection.createNode file, @
      dispatchStartStream.write file
      done!
    #
    # return stream
    #
    stream
}
