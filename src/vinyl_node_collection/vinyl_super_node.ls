module.exports = VinylSuperNode

!function VinylSuperNode (collection, @fromNode, @isRequireState, keyPath)
  if '.' is keyPath.charAt 0 # relative
    keyPath = fromNode.filepathFrom keyPath
  @filepathMatcher = new RegExp "^#{ keyPath }"

VinylSuperNode::_toList = !(state, collection) ->
  state.addNode collection.matchFilepath @filepathMatcher, @fromNode
