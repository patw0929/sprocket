require! {
  util
  path
}

class SuperNode

  !->
    const keyPath = BaseSuperNode ...
    @_filepathMatcher = new RegExp "^#{ keyPath }"

class Directory

  !->
    const keyPath = BaseSuperNode ...
    @_filepathMatcher = new RegExp "^#{ keyPath }((?!#{ path.sep }).)*$"

SuperNode <<< {Directory}

module.exports = SuperNode
#
# internal
# returns parsed keyPath
function BaseSuperNode (collection, @fromNode, dependency)
  {@isRequireState, keyPath} = dependency
  if '.' is keyPath.charAt 0
    # is relative, translate to absolute path
    path.join path.dirname(fromNode.vinyl.path), keyPath, path.sep
  else
    keyPath

function pathSortFn (l, r)
  l.path - r.path

const prototype = do

  _buildDependencies: !(state) ->
    @_filepathMatchedNodes state._collection._nodes
    .sort pathSortFn
    .forEach !-> it.buildDependencies state

  _filepathMatchedNodes: (_nodes) ->
    const {fromNode, _filepathMatcher} = @
    for keyPath, vn of _nodes
      vn if vn isnt fromNode and vn.pathMatches _filepathMatcher

SuperNode::<<< prototype
Directory::<<< prototype
