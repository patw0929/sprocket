module.exports = Edge
Edge <<< {Circular}

!function Edge (@fromNode, @isRequireState, options)
  @toNode = options.collection.createNodeWith options.keyPath

Edge::_buildDependencies = !(state, collection) ->
  @toNode.buildDependencies state, collection

!function Circular (@fromNode, @isRequireState, options)
  @toNode = fromNode

Circular::_buildDependencies = !(state, collection) ->
  const {toNode} = @
  state.addNode [toNode] unless state.requiredBefore toNode.keyPath
