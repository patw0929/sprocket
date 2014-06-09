require! {
  os
  path
  crypto
  File: vinyl
}

module.exports = RequireState

const MANIFEST_EXTNAME = '.manifest.json'

RequireState <<< {keyPath2BaseAndExtnames, MANIFEST_EXTNAME}

!function RequireState
  @_inRequireStates = [true]
  @_keyPaths = {}
  @_nodes = []
  @_totalBufferSize = 0
  @_md5 = crypto.createHash 'md5'

function keyPath2BaseAndExtnames ({keyPath, isProduction, extname})
  const extnames = [extname]
  extnames.unshift '.min' if isProduction
  [
    path.join path.dirname(keyPath), path.basename(keyPath)
    extnames.join('')
  ]
/*
 * RequireState.prototype
 */
const EOL_BUF = new Buffer os.EOL

RequireState::<<< {
  pushState: !-> @_inRequireStates.push it
  popState: !-> @_inRequireStates.pop!

  requiredBefore: (keyPath) ->
    @_inRequireStates[*-1] and keyPath of @_keyPaths

  addNode: !(node) ->
    const {vinyl, keyPath} = node
    return if @requiredBefore keyPath
    @_keyPaths[keyPath] = true
    @_nodes.push node
    @_totalBufferSize += that.length if vinyl.contents

  addNodeArray: !-> it.forEach @addNode, @

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

function bufferFromPaths (pathsArray)
  new Buffer JSON.stringify pathsArray, null, 2
