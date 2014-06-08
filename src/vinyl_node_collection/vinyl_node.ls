require! {
  path
}
require! {
  VinylNodeEdge: './vinyl_node_edge'
  VinylSuperNode: './vinyl_super_node'
}

module.exports = VinylNode

VinylNodeEdge::<<< {buildDependencies}
VinylSuperNode::<<< {buildDependencies}

!function buildDependencies (state, collection)
  state.pushState @isRequireState
  try     @_buildDependencies state, collection
  finally state.popState!
/*
 * VinylNode
 */
!function VinylNode (@keyPath)
  @vinyl = @dependencies = void

VinylNode::<<< {
  canBeEntry: -> @dependencies.length

  filepathFrom: (keyPath) ->
    path.join do
      path.dirname @vinyl.path
      keyPath

  matchFilepath: (filepathMatcher) ->
    @vinyl.path.match filepathMatcher

  buildDependencies: !(state, collection) ->
    return if state.requiredBefore @keyPath
    @dependencies.forEach !-> it.buildDependencies state, collection
    state.addNode [@] unless state.requiredBefore @keyPath
}
