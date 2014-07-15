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
    @_engines            = Object.create(Sprockets._engines)
    @_engine_extensions  = Object.create(Sprockets._engine_extensions)
    @_mime_exts          = Object.create(Sprockets._mime_exts)
    @_mime_types         = Object.create(Sprockets._mime_types)
    @_templates          = Object.create(Sprockets._templates)
    @_preprocessors      = Object.create(Sprockets._preprocessors)
    @postprocessors     = Object.create(Sprockets.postprocessors)
    #
    @view_locals        = Object.create(Sprockets.viewLocals)
    #
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
    -> Locals.call Object.create(@view_locals), @

  createJavascriptsStream: ->
    @_createStream 'application/javascript'

  createStylesheetsStream: ->
    @_createStream 'text/css'

  createHtmlsStream: ->
    @_createStream 'text/html'

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
    const targetExtention = @_mime_types[mime_type].extensions.0
    const collection = @vinyl_node_collections[mime_type] ||= new VinylNodeCollection('text/html' is mime_type)
    collection.updateVersion!

    ~function createTemplates(extname)
      const passThroughStream = new PassThrough objectMode: true
      @_templates[extname](@, passThroughStream, dispatchEngineStream)
      passThroughStream

    function getOrCreateTemplates(extname)
      tplEngines[extname] ||= createTemplates(extname)

    ~function createEngines(extname)
      const passThroughStream = new PassThrough objectMode: true
      #
      @_engines[extname](@, passThroughStream, dispatchEngineStream)
      passThroughStream

    function getOrCreateEngines(extname)
      extEngines[extname] ||= createEngines(extname)
    #
    # create a templates, engines stream map to to transformation
    #
    const tplEngines = {}
    const extEngines = {}
    const dispatchStartStream = new Transform objectMode: true
    dispatchStartStream._transform = !(file, enc, done) ~>
      const extname = path.extname file.path
      # has more than one extname, treat last one as template
      if path.extname(path.basename file.path, extname) and @_templates[extname]
        getOrCreateTemplates(extname).write file
      else
        getOrCreateEngines(extname).write file
      done!

    const dispatchEngineStream = new Transform objectMode: true
    dispatchEngineStream._transform = !(file, enc, done) ~>
      getOrCreateEngines(path.extname file.path).write file
      done!
    #
    # link the target extension stream up
    #
    const dispatchEndStream = new Transform objectMode: true
    dispatchEndStream._transform = !(file, enc, done) ->
      collection.finalizeNode file, stream
      stream._endEventually!
      done!
   
    extEngines[targetExtention] = new PassThrough objectMode: true
    @_engines[targetExtention](@, extEngines[targetExtention], dispatchEndStream)
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
    const {mimeType} = stream
    const Postprocessor = @postprocessors[mimeType]
    const collection = @vinyl_node_collections[mimeType]
    new Postprocessor @, collection, stream
    .process!
}