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
    @_postprocessors     = Object.create(Sprockets._postprocessors)
    #
    @_view_locals        = Object.create(Sprockets.viewLocals)
    #
    @_manifest_filepaths = {}
    @_vinyl_node_collections = {}
    #
    @_is_produciton = process.env.NODE_ENV is 'production'
    @_base_paths = []
    
  isProduction:~
    -> @_is_produciton

  basePaths:~
    #
    # HACK: 
    # returns a direct reference for Sass/LESS @import paths
    # gulp-sass.options.includePaths
    # gulp-less.options.paths
    # since it is lazy evaluated during transforming state
    #
    -> @_base_paths

  viewLocals:~
    -> Locals.call Object.create(@_view_locals), @

  createJavascriptsStream: ->
    @_create_stream 'application/javascript'

  createStylesheetsStream: ->
    @_create_stream 'text/css'

  createHtmlsStream: ->
    @_create_stream 'text/html'
  #
  # Private APIs
  #
  add_base_path: ->
    const {_base_paths} = @
    [return false for basePath in _base_paths when basePath is it]
    !!_base_paths.push it

  const {Transform, PassThrough} = Stream

  _create_stream: (mime_type) ->
    const targetExtention = @_mime_types[mime_type].extensions.0
    const collection = @_vinyl_node_collections[mime_type] ||= new VinylNodeCollection('text/html' is mime_type)
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

  end_stream: !(stream) ->
    const {mimeType} = stream
    const Postprocessor = @_postprocessors[mimeType]
    const collection = @_vinyl_node_collections[mimeType]
    new Postprocessor @, collection, stream
    .process!

module.exports =  Environment
