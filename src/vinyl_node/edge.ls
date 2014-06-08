module.exports = VinylNodeEdge

!function VinylNodeEdge (@fromNode, @isRequireState, options)
  @toNode = options.collection.createNodeWith options.keyPath

VinylNodeEdge::_buildDependencies = !(state, collection) ->
  @toNode.buildDependencies state, collection
