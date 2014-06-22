module.exports = Edge
Edge <<< {Circular}

!function Edge (collection, @fromNode, dependency)
  {@isRequireState} = dependency
  @toNode = collection._createNodeWith dependency.keyPath

Edge::_buildDependencies = !(state) ->
  @toNode.buildDependencies state

!function Circular (collection, @fromNode, {@isRequireState})
  @toNode = fromNode

Circular::_buildDependencies = !(state) ->
  #
  # We cannot call toNode.buildDependencies here since
  # it would call recursively and overflow the stack!
  #
  state.addNodeIfNeeded @toNode
