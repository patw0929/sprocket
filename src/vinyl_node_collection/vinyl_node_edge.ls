module.exports = VinylNodeEdge

!function VinylNodeEdge (collection, @fromNode, @isRequireState, keyPath)
  @toNode = collection._createNode keyPath

VinylNodeEdge::_buildDependencies = !(state, collection) ->
  @toNode.buildDependencies state, collection
