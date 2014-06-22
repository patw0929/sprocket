require! {
  path
  Stream: 'stream'
}
require! {
  Sprockets: '../index'
  VinylNodeCollection: '../vinyl_node_collection'
  RequireState: '../vinyl_node_collection/require_state'
  Base: './base'
  Locals: './locals'
  SprocketsStream: './stream'
}

class Environment extends Base

  !->
    @engines = Object.create(Sprockets.engines)
    @engine_extensions = Object.create(Sprockets.engine_extensions)
    @mime_exts = Object.create(Sprockets.mime_exts)
    @mime_types = Object.create(Sprockets.mime_types)
    @manifest_filepaths = {}
    @vinyl_node_collections = {}
    #
    @is_produciton = process.env.NODE_ENV is 'production'
    @base_paths = []
    
  isProduction:~
    -> @is_produciton

  basePaths:~
    #
    # HACK: 
    # returns a direct reference for Sass/LESS @import paths
    # gulp-sass.options.includePaths
    # gulp-less.options.paths
    # since it is lazy evaluated during transforming state
    #
    -> @base_paths

  viewLocals:~
    -> new Locals @

  createJavascriptsStream: ->
    @_createStream 'application/javascript'

  createStylesheetsStream: ->
    @_createStream 'text/css'

module.exports =  Environment
# 
# Private APIs
# 
const {Transform, PassThrough} = Stream
Environment::<<< {

  _addBasePath: ->
    const {base_paths} = @
    [return false for basePath in base_paths when basePath is it]
    !!base_paths.push it

  _createStream: (mime_type) ->
    const targetExtention = @mime_types[mime_type].extensions.0
    const collection = @vinyl_node_collections[mime_type] ||= new VinylNodeCollection!
    collection.updateVersion!
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
      #
      extEngines[engineExtension] = passThroughStream
      @engines[engineExtension](@, passThroughStream, dispatchStartStream)
    #
    # link the target extension stream up
    #
    const dispatchEndStream = new Transform objectMode: true
    dispatchEndStream._transform = !(file, enc, done) ->
      collection.finalizeNode file, stream
      stream._endEventually!
      done!
   
    extEngines[targetExtention] = new PassThrough objectMode: true
    @engines[targetExtention](@, extEngines[targetExtention], dispatchEndStream)
    #
    # setup stream that we want to return
    #
    const stream = new SprocketsStream {
      mimeType: mime_type
      environment: @
      collection
      dispatchStartStream
    }

  _endStream: !(stream) ->
    const eachFn = (if @isProduction then @_bundle else @_manifest).bind @, stream
    @vinyl_node_collections[stream.mimeType]
      .createRequireStates!
      .forEach eachFn
}