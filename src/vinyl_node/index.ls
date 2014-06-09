require! {
  path
}
require! {
  Collection: './collection'
  Edge: './edge'
  SuperNode: './super_node'
  RequireState: './require_state'
}

module.exports = VinylNode
VinylNode <<< {Collection, RequireState}
Collection <<< {VinylNode, Edge, SuperNode}
/*
 * VinylNode
 */
!function VinylNode (@keyPath)
  @vinyl = @dependencies = void
  @isStable = false
/*
 * VinylNode.prototype
 */
const {prototype} = VinylNode
prototype<<< {
  hasDependencies:~
    -> @dependencies.length

  buildDependencies: !(state, collection) ->
    return if state.requiredBefore @keyPath
    @dependencies.forEach !-> it.buildDependencies state, collection
    state.addNode [@] unless state.requiredBefore @keyPath
}
/*
 * Private APIs
 */
prototype<<< {
  _filepathFrom: (keyPath) ->
    path.join do
      path.dirname @vinyl.path
      keyPath
      path.sep

  _matchFilepath: (superNode) ->
    @vinyl.path.match superNode._filepathMatcher
}

Edge::<<< {buildDependencies}
Edge.Circular::<<< {buildDependencies}
SuperNode::<<< {buildDependencies}
SuperNode.Directory::<<< {buildDependencies}

!function buildDependencies (state, collection)
  state.pushState @isRequireState
  try     @_buildDependencies state, collection
  finally state.popState!
