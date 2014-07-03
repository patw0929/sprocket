require! {
  os
  path
  File: vinyl
}

const EOL_BUF = new Buffer(os.EOL)

const MANIFEST_BASENAME = '-manifest'
const MANIFEST_EXTNAME = '.json'

class BundleOrManifest

  !(@environment, @collection, @stream) ->
    {@mimeType} = stream
    @outputtedPaths = {}

  process: !->
    const fn = if @environment.isProduction then @bundle else @manifest
    @collection.createRequireStates!.forEach fn, @

  bundle: !(requireState) ->
    const {keyPath, vinyls} = requireState
    const dirname   = path.dirname keyPath
    const basename  = path.basename keyPath
    const extname   = ".min#{ @environment.extnameForMimeType @mimeType }"    
    const contents  = requireState.bufferWithSeperator(EOL_BUF)
    #
    targetStart = 0
    for vinyl in vinyls
      for sourceBuffer in [vinyl.contents, EOL_BUF]
        sourceBuffer.copy contents, targetStart
        targetStart += sourceBuffer.length
    #
    const fingerprint = @environment.hexDigestFor contents
    const filepath = path.join dirname, "#basename-#fingerprint#extname"
    #
    @stream.push new File do
      path: filepath
      contents: contents
    
    const relativeFilepaths = [filepath]
    @environment.setManifestFilepaths @mimeType, keyPath, relativeFilepaths
    @stream.push new File do
      path: path.join dirname, "#basename#MANIFEST_BASENAME#extname#MANIFEST_EXTNAME"
      contents: new Buffer(JSON.stringify relativeFilepaths)

  manifest: !(requireState) ->
    const {pathsChanged, nothingChanged, vinyls, keyPath} = requireState
    return if nothingChanged

    const relativeFilepaths = vinyls.map (vinyl) ->
      const {path} = vinyl
      if pathsChanged[path] and !@outputtedPaths[path]
        @outputtedPaths[path] = true
        @stream.push vinyl
      vinyl.relative
    , @

    @environment.setManifestFilepaths @mimeType, keyPath, relativeFilepaths

    const dirname   = path.dirname keyPath
    const basename  = path.basename keyPath
    const extname   = @environment.extnameForMimeType @mimeType

    @stream.push new File do
      path: path.join dirname, "#basename#MANIFEST_BASENAME#extname#MANIFEST_EXTNAME"
      contents: new Buffer(JSON.stringify relativeFilepaths, null, 2)

module.exports = BundleOrManifest
  