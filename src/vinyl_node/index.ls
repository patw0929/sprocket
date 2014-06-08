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
/*
 * Private APIs
 */

Edge::<<< {buildDependencies}
Edge.Circular::<<< {buildDependencies}
SuperNode::<<< {buildDependencies}

!function buildDependencies (state, collection)
  state.pushState @isRequireState
  try     @_buildDependencies state, collection
  finally state.popState!
