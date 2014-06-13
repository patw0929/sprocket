require! {
  util
  path
}

module.exports = SuperNode
SuperNode <<< {Directory}
#
# internal
# returns parsed keyPath
function BaseSuperNode (collection, @fromNode, options)
  {@isRequireState, keyPath} = options
  if '.' is keyPath.charAt 0 # relative
    fromNode._filepathFrom keyPath
  else
    keyPath

BaseSuperNode::<<<{

  _buildDependencies: !(state, collection) ->
    @_matchFilepath collection._nodes
    .sort (l, r) -> l.vinyl.path - r.vinyl.path
    |> state.addNodeArray

  _matchFilepath: (_nodes) ->
    for keyPath, vn of _nodes
      vn if vn._matchFilepath @ and vn isnt @fromNode
}

util.inherits SuperNode, BaseSuperNode
!function SuperNode
  const keyPath = BaseSuperNode ...
  @_filepathMatcher = new RegExp "^#{ keyPath }"

util.inherits Directory, BaseSuperNode
!function Directory
  const keyPath = BaseSuperNode ...
  @_filepathMatcher = new RegExp "^#{ keyPath }((?!#{ path.sep }).)*$"
