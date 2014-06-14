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
  if '.' is keyPath.charAt 0
    # is relative, translate to absolute path
    path.join path.dirname(fromNode.path), keyPath, path.sep
  else
    keyPath

function pathSortFn (l, r)
  l.path - r.path

BaseSuperNode::<<<{

  _buildDependencies: !(state, collection) ->
    @_filepathMatchedNodes collection._nodes
    .sort pathSortFn
    .forEach !-> it.buildDependencies state, collection

  _filepathMatchedNodes: (_nodes) ->
    const {fromNode, _filepathMatcher} = @
    for keyPath, vn of _nodes
      vn if vn isnt fromNode and vn.path.match _filepathMatcher
}

util.inherits SuperNode, BaseSuperNode
!function SuperNode
  const keyPath = BaseSuperNode ...
  @_filepathMatcher = new RegExp "^#{ keyPath }"

util.inherits Directory, BaseSuperNode
!function Directory
  const keyPath = BaseSuperNode ...
  @_filepathMatcher = new RegExp "^#{ keyPath }((?!#{ path.sep }).)*$"
