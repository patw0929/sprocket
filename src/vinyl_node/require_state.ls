module.exports = RequireState

!function RequireState
  @_inRequireStates = [true]
  @_keyPaths = {}
  @_nodes = []
  @_totalBufferSize = 0
/*
 * RequireState.prototype
 */
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
}
