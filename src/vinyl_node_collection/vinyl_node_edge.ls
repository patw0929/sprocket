module.exports = VinylNodeEdge

!function VinylNodeEdge (collection, @fromNode, @isRequireState, keyPath)
  @toNode = collection._createNode keyPath

VinylNodeEdge::_toList = !(state, collection) ->
  @toNode.toList state, collection
