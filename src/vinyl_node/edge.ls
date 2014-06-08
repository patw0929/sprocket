module.exports = Edge
Edge <<< {Circular}

!function Edge (@fromNode, @isRequireState, options)
  @toNode = options.collection.createNodeWith options.keyPath

_buildDependencies = !(state, collection) ->
  @toNode.buildDependencies state, collection

Edge::<<< {_buildDependencies}
Circular::<<< {_buildDependencies}

!function Circular (@fromNode, @isRequireState, options)
  @toNode = fromNode
