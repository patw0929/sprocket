module.exports = RequireState

!function RequireState
  @_inRequireStates = [true]
  @_keyPaths = {}
  @_nodes = []

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

  dumpNodes: -> @_nodes
}
