require! {
  path
  File: vinyl
}

const MANIFEST_BASENAME = '-manifest'
const MANIFEST_EXTNAME = '.json'

module.exports = do
  getManifestFilepaths: (mimeType, keyPath) ->
    @manifest_filepaths[mimeType + keyPath]

  setManifestFilepaths: (mimeType, keyPath, filepaths) ->
    @manifest_filepaths[mimeType + keyPath] = filepaths

  _manifest: !(stream, requireState) ->
    stream.outputted_paths ||= {}
    const relativeFilepaths = requireState.vinyls.map (vinyl) ->
      unless @outputted_paths[vinyl.path]
        @outputted_paths[vinyl.path] = true
        @push vinyl
      vinyl.relative
    , stream

    const {mimeType} = stream
    const {keyPath} = requireState
    @setManifestFilepaths mimeType, keyPath, relativeFilepaths

    const dirname   = path.dirname keyPath
    const basename  = path.basename keyPath
    const extname   = @mime_types[mimeType].extensions.0

    stream.push new File do
      path: path.join dirname, "#basename-#MANIFEST_BASENAME#extname#MANIFEST_EXTNAME"
      contents: new Buffer(JSON.stringify relativeFilepaths, null, 2)
