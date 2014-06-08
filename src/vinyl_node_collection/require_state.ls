require! {
  os
  path
  File: vinyl
}

module.exports = RequireState

const MANIFEST_EXTNAME = '.manifest.json'

RequireState <<< {keyPath2Filepath, MANIFEST_EXTNAME}

!function RequireState
  @_inRequireStates = [true]
  @_keyPaths = {}
  @_nodes = []

function keyPath2Filepath ({keyPath, isProduction, extname})
  const basename = [
    path.basename(keyPath)
    extname
  ]
  basename.splice 1, 0, '.min' if isProduction
  path.join path.dirname(keyPath), basename.join('')
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

  concatFile: !(vinyls, keyPath, filepath) ->
    const {length} = @_nodes
    const buffers = []
    totalSize = length * EOL_BUF.length

    @_nodes.forEach !->
      if it.vinyl.contents
        totalSize += that.length
        buffers.push that
      buffers.push EOL_BUF

    vinyls[keyPath] = new File do
      path: filepath
      contents: Buffer.concat buffers, totalSize

    const manifestFilepath = filepath + MANIFEST_EXTNAME
    vinyls[manifestFilepath] = new File do
      path: manifestFilepath
      contents: new Buffer JSON.stringify [filepath]

  buildManifestFile: !(vinyls, keyPath, filepath) ->
    filepath += MANIFEST_EXTNAME

    vinyls[filepath] = new File do
      path: filepath
      contents: new Buffer JSON.stringify @_nodes.map (vn) ->
        const {vinyl} = vn
        vinyls[vn.keyPath] = vinyl
        vinyl.relative
}
