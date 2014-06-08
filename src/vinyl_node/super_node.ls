module.exports = VinylSuperNode

!function VinylSuperNode (@fromNode, @isRequireState, {keyPath})
  if '.' is keyPath.charAt 0 # relative
    keyPath = fromNode.filepathFrom keyPath
  @_filepathMatcher = new RegExp "^#{ keyPath }"

VinylSuperNode::<<<{

  _buildDependencies: !(state, collection) ->
    state.addNode @_matchFilepath collection._nodes

  _matchFilepath: (_nodes) ->
    const array = for keyPath, vn of @_nodes
      when vn.matchFilepath @_filepathMatcher and vn isnt @fromNode
        vn
    array.sort (l, r) -> l.vinyl.path - r.vinyl.path
}
