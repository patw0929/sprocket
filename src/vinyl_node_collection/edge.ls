module.exports = Edge
Edge <<< {Circular}

!function Edge (collection, @fromNode, dependency)
  {@isRequireState} = dependency
  @toNode = collection._createNodeWith dependency.keyPath

Edge::_build_dependencies = !(state) ->
  @toNode.build_dependencies state

!function Circular (collection, @fromNode, {@isRequireState})
  @toNode = fromNode

Circular::_build_dependencies = !(state) ->
  #
  # We cannot call toNode.build_dependencies here since
  # it would call recursively and overflow the stack!
  #
  state.include_node @toNode
