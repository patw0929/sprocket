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

module.exports = SprocketRequireState
SprocketRequireState <<< {getManifestFilepath}

/*                           ({keyPath, isProduction, extname}) */
function getManifestFilepath (baseAndExtnames)
  baseAndExtnames = keyPath2BaseAndExtnames ...& unless Array.isArray baseAndExtnames
  baseAndExtnames.push MANIFEST_EXTNAME
  baseAndExtnames.join('')
/*
 * SprocketRequireState
 */
util.inherits SprocketRequireState, RequireState
[SprocketRequireState[k] = v for k, v of RequireState]
!function SprocketRequireState
  RequireState ...
  @_md5 = crypto.createHash 'md5'
/*
 * SprocketRequireState.prototype
 */
const EOL_BUF = new Buffer os.EOL

SprocketRequireState::<<< {

  concatFile: !(manifestFiles, vinyls, options) ->
    const baseAndExtnames = keyPath2BaseAndExtnames options
    const basename = baseAndExtnames.0
    const {_nodes} = @
    const contents = new Buffer(@_totalBufferSize + _nodes.length * EOL_BUF.length)
    #
    targetStart = 0
    for node in _nodes when node.vinyl.contents
      for sourceBuffer in [that, EOL_BUF]
        sourceBuffer.copy contents, targetStart
        targetStart += sourceBuffer.length

    const fingerprint = @_md5.update contents .digest 'hex' .slice 0, 32
    const filepath = "#basename-#fingerprint#{ baseAndExtnames.1 }"

    vinyls[basename] = new File do
      path: filepath
      contents: contents
    #
    createManifestVinyl manifestFiles, vinyls, baseAndExtnames, [filepath]

  buildManifestFile: !(manifestFiles, vinyls, options) ->
    createManifestVinyl manifestFiles, vinyls, options,  @_nodes.map (vn) ->
      const {vinyl} = vn
      vinyls[vn.keyPath] = vinyl
      vinyl.relative
}
const MANIFEST_BASENAME = '-manifest'
const MANIFEST_EXTNAME = '.json'

function keyPath2BaseAndExtnames ({keyPath, isProduction, extname})
  const extnames = [extname]
  extnames.unshift '.min' if isProduction
  [
    path.join path.dirname(keyPath), "#{ path.basename(keyPath) }#{ MANIFEST_BASENAME }"
    extnames.join('')
  ]

!function createManifestVinyl (manifestFiles, vinyls, options, pathsArray)
  const manifestFilepath = getManifestFilepath options
  vinyls[manifestFilepath] = new File do
    path: manifestFilepath
    contents: new Buffer JSON.stringify pathsArray, null, 2
  manifestFiles[manifestFilepath] = pathsArray
