require! {
  path
}
require! {
  VinylNodeEdge: './vinyl_node_edge'
  VinylSuperNode: './vinyl_super_node'
}

module.exports = VinylNode

VinylNodeEdge::toList = VinylSuperNode::toList = (state, collection) ->
  state.pushState @isRequireState
  try     @_toList state, collection
  finally state.popState!

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

  toList: !(state, collection) ->
    return if state.requiredBefore @keyPath
    @dependencies.forEach !-> it.toList state, collection
    state.addNode [@] unless state.requiredBefore @keyPath
}
