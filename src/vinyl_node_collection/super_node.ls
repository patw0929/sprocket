require! {
  util
  path
}

class SuperNode

  !->
    const keyPath = BaseSuperNode ...
    @_filepath_matcher = new RegExp "^#{ keyPath }"

class Directory

  !->
    const keyPath = BaseSuperNode ...
    @_filepath_matcher = new RegExp "^#{ keyPath }((?!#{ path.sep }).)*$"

SuperNode <<< {Directory}

module.exports = SuperNode
#
# internal
# returns parsed keyPath
function BaseSuperNode (collection, @fromNode, dependency)
  {@isRequireState, keyPath} = dependency
  if '.' is keyPath.charAt 0
    # is relative, translate to absolute path
    fromNode.resolve_key_path keyPath
  else
    keyPath

function pathSortFn (l, r)
  l.path - r.path

const prototype = do

  _build_dependencies: !(state) ->
    @_nodes_match_filepath state._collection._nodes
    .sort pathSortFn
    .forEach !-> it.buildDependencies state

  _nodes_match_filepath: (_nodes) ->
    const {fromNode, _filepath_matcher} = @
    for keyPath, vn of _nodes
      vn if vn isnt fromNode and vn.pathMatches _filepath_matcher

SuperNode::<<< prototype
Directory::<<< prototype
