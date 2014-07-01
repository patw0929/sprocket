require! {
  util
  path
}
require! {
  Node: './node'
  Edge: './edge'
  SuperNode: './super_node'
  RequireState: './require_state'
}

class Collection

  !->
    @_nodes = {}
    @_version = Date.now!

  vinyls:~
    -> [vn.vinyl for keyPath, vn of @_nodes]

  version:~
    -> @_version

  updateVersion: !->
    @_version = Date.now!

  isStable:~
    ->
      [return false for keyPath, vn of @_nodes when vn.isUnstable @] 
      true

  createNode: (vinyl, stream) ->
    @_createNodeWith vinyl.relative
      .tryUnstablize @, vinyl

  finalizeNode: !(vinyl, stream) ->
    const [keyPathWithMin, keyPath] = parseKeyPath vinyl.relative
    const fromNode = (keyPathWithMin and @_nodes[keyPathWithMin]) or @_nodes[keyPath]
    if fromNode
      fromNode.stablize @, vinyl
    else
      stream.emit 'error' "[VinylNode.Collection] Can't finalize node (#{ vinyl.path })"

  createRequireStates: ->
    for keyPath, node of @_nodes when node.hasAnyEdges
      node.buildDependencies new RequireState(keyPath, @)

module.exports = Collection
/*
 * Private APIs
 */
function parseKeyPath (relative)
  const [keyPath, firstExtname] = relative.split '.'
  if 'min' is firstExtname
    ["#{keyPath}__iLoveSprocket__min", keyPath]
  else
    [void, keyPath]

Collection::<<< {
  _createNodeWith: (/* relative_or_rawKeyPath */) ->
    const parsedKeyPaths = parseKeyPath it
    const keyPath = parsedKeyPaths.shift! or parsedKeyPaths.0
    @_nodes[keyPath] ||= new Node keyPath
}
