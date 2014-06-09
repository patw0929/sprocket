module.exports = Edge
Edge <<< {Circular}

!function Edge (@fromNode, @isRequireState, options)
  @toNode = options.collection.createNodeWith options.keyPath

Edge::_buildDependencies = !(state, collection) ->
  @toNode.buildDependencies state, collection

!function Circular (@fromNode, @isRequireState, options)
  @toNode = fromNode

Circular::_buildDependencies = !(state, collection) ->
  #
  # We cannot call toNode.buildDependencies here since
  # it would call recursively and overflow the stack!
  #
  const {toNode} = @
  state.addNode [toNode] unless state.requiredBefore toNode.keyPath
