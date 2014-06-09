module.exports = SuperNode

!function SuperNode (@fromNode, @isRequireState, {keyPath})
  if '.' is keyPath.charAt 0 # relative
    keyPath = fromNode._filepathFrom keyPath
  @_filepathMatcher = new RegExp "^#{ keyPath }"

SuperNode::<<<{

  _buildDependencies: !(state, collection) ->
    @_matchFilepath collection._nodes
    .sort (l, r) -> l.vinyl.path - r.vinyl.path
    |> state.addNode

  _matchFilepath: (_nodes) ->
    for keyPath, vn of _nodes
      vn if vn._matchFilepath @ and vn isnt @fromNode
}
