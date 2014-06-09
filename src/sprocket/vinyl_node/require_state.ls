require! {
  os
  util
  path
  crypto
}
require! {
  File: vinyl
  RequireState: '../../vinyl_node/require_state'
}

const MANIFEST_EXTNAME = '.manifest.json'

module.exports = SprocketRequireState
SprocketRequireState <<< {keyPath2BaseAndExtnames, MANIFEST_EXTNAME}

function keyPath2BaseAndExtnames ({keyPath, isProduction, extname})
  const extnames = [extname]
  extnames.unshift '.min' if isProduction
  [
    path.join path.dirname(keyPath), path.basename(keyPath)
    extnames.join('')
  ]
/*
 * SprocketRequireState
 */
util.inherits SprocketRequireState, RequireState
!function SprocketRequireState
  RequireState ...
  @_md5 = crypto.createHash 'md5'
/*
 * SprocketRequireState.prototype
 */
SprocketRequireState::<<< {

  concatFile: !(vinyls, [basename, extnames]) ->
    const {_nodes} = @
    const contents = new Buffer(@_totalBufferSize + _nodes.length * EOL_BUF.length)
    #
    targetStart = 0
    for node in _nodes when node.vinyl.contents
      for sourceBuffer in [that, EOL_BUF]
        sourceBuffer.copy contents, targetStart
        targetStart += sourceBuffer.length

    const fingerprint = @_md5.update contents .digest 'hex' .slice 0, 32
    const filepath = "#basename-#fingerprint#extnames"

    vinyls[basename] = new File do
      path: filepath
      contents: contents

    const manifestFilepath = basename + extnames + MANIFEST_EXTNAME
    vinyls[manifestFilepath] = new File do
      path: manifestFilepath
      contents: bufferFromPaths [filepath]

  buildManifestFile: !(vinyls, baseAndExtnames) ->
    const filepath = baseAndExtnames.join('')
    baseAndExtnames.push MANIFEST_EXTNAME

    vinyls[filepath] = new File do
      path: baseAndExtnames.join('')
      contents: bufferFromPaths @_nodes.map (vn) ->
        const {vinyl} = vn
        vinyls[vn.keyPath] = vinyl
        vinyl.relative
}
const EOL_BUF = new Buffer os.EOL

function bufferFromPaths (pathsArray)
  new Buffer JSON.stringify pathsArray, null, 2
