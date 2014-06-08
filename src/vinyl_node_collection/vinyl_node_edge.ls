module.exports = VinylNodeEdge

!function VinylNodeEdge (collection, @fromNode, @isRequireState, keyPath)
  @toNode = collection.createNodeWith keyPath

VinylNodeEdge::_buildDependencies = !(state, collection) ->
  @toNode.buildDependencies state, collection
