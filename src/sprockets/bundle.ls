require! {
  os
  path
  File: vinyl
}
const EOL_BUF = new Buffer(os.EOL)

const MANIFEST_BASENAME = '-manifest'
const MANIFEST_EXTNAME = '.json'

module.exports = do
  _bundle: !(stream, requireState) ->
    const {mimeType} = stream
    const {keyPath, vinyls} = requireState
    const dirname   = path.dirname keyPath
    const basename  = path.basename keyPath
    const extname   = ".min#{ @mime_types[mimeType].extensions.0 }"    
    const contents  = requireState.bufferWithSeperator(EOL_BUF)
    #
    targetStart = 0
    for vinyl in vinyls
      for sourceBuffer in [vinyl.contents, EOL_BUF]
        sourceBuffer.copy contents, targetStart
        targetStart += sourceBuffer.length
    #
    const fingerprint = @digestHash.update contents .digest 'hex' .slice 0, 32
    const filepath = path.join dirname, "#basename-#fingerprint#extname"
    #
    stream.push new File do
      path: filepath
      contents: contents
    
    const relativeFilepaths = [filepath]
    @setManifestFilepaths mimeType, keyPath, relativeFilepaths
    stream.push new File do
      path: path.join dirname, "#basename#MANIFEST_BASENAME#extname#MANIFEST_EXTNAME"
      contents: new Buffer(JSON.stringify relativeFilepaths)
