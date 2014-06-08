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

  addNode: !(nodes) ->
    (node) <~! nodes.forEach
    const {keyPath} = node
    return if @requiredBefore keyPath
    @_keyPaths[keyPath] = true
    @_nodes.push node

  concatFile: !(vinyls, [basename, extnames]) ->
    const {length} = @_nodes
    const buffers = []
    totalSize = length * EOL_BUF.length

    @_nodes.forEach !->
      if it.vinyl.contents
        totalSize += that.length
        buffers.push that
      buffers.push EOL_BUF

    const contents = Buffer.concat buffers, totalSize
    const fingerprint = @_md5.update contents .digest 'hex' .slice 0, 32
    const filepath = "#basename-#fingerprint#extnames"

    vinyls[basename] = new File do
      path: filepath
      contents: contents

    const manifestFilepath = basename + extnames + MANIFEST_EXTNAME
    vinyls[manifestFilepath] = new File do
      path: manifestFilepath
      contents: new Buffer JSON.stringify [filepath]

  buildManifestFile: !(vinyls, baseAndExtnames) ->
    const filepath = baseAndExtnames.join('')
    baseAndExtnames.push MANIFEST_EXTNAME

    vinyls[filepath] = new File do
      path: baseAndExtnames.join('')
      contents: new Buffer JSON.stringify @_nodes.map (vn) ->
        const {vinyl} = vn
        vinyls[vn.keyPath] = vinyl
        vinyl.relative
}
