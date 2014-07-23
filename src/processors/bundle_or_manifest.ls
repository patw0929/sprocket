require! {
  os
  path
  File: vinyl
}

const EOL_BUF = new Buffer(os.EOL)

const MANIFEST_BASENAME = '-manifest'
const MANIFEST_EXTNAME = '.json'

class BundleOrManifest

  !(@_environment, @_collection, @_stream) ->
    @_mime_type = _stream.mimeType
    @outputtedPaths = {}

  process: !->
    const fn = if @_environment.isProduction then @_bundle else @_manifest
    @_collection.createRequireStates!.forEach fn, @

  _bundle: !(requireState) ->
    const {keyPath, vinyls} = requireState
    const dirname   = path.dirname keyPath
    const basename  = path.basename keyPath
    const extname   = ".min#{ @_environment.extnameForMimeType @_mime_type }"    
    const contents  = requireState.bufferWithSeperator(EOL_BUF)
    #
    targetStart = 0
    for vinyl in vinyls
      for sourceBuffer in [vinyl.contents, EOL_BUF]
        sourceBuffer.copy contents, targetStart
        targetStart += sourceBuffer.length
    #
    const fingerprint = @_environment.hexDigestFor contents
    const filepath = path.join dirname, "#basename-#fingerprint#extname"
    #
    @_stream.push new File do
      path: filepath
      contents: contents
    
    const relativeFilepaths = [filepath]
    @_environment.setManifestFilepaths @_mime_type, keyPath, relativeFilepaths
    @_stream.push new File do
      path: path.join dirname, "#basename#MANIFEST_BASENAME#extname#MANIFEST_EXTNAME"
      contents: new Buffer(JSON.stringify relativeFilepaths)

  _manifest: !(requireState) ->
    const {pathsChanged, nothingChanged, vinyls, keyPath} = requireState
    return if nothingChanged

    const relativeFilepaths = vinyls.map (vinyl) ->
      const {path} = vinyl
      if pathsChanged[path] and !@outputtedPaths[path]
        @outputtedPaths[path] = true
        @_stream.push vinyl
      vinyl.relative
    , @

    @_environment.setManifestFilepaths @_mime_type, keyPath, relativeFilepaths

    const dirname   = path.dirname keyPath
    const basename  = path.basename keyPath
    const extname   = @_environment.extnameForMimeType @_mime_type

    @_stream.push new File do
      path: path.join dirname, "#basename#MANIFEST_BASENAME#extname#MANIFEST_EXTNAME"
      contents: new Buffer(JSON.stringify relativeFilepaths, null, 2)

module.exports = BundleOrManifest
  