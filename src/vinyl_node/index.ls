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

module.exports = Collection
Collection <<< {RequireState, Node, Edge, SuperNode}

!function Collection
  @_nodes = {}
/*
 * Collection.prototype
 */
const {prototype} = Collection
/*
 * Public APIs
 */
prototype <<< {
  isStable:~
    ->
      for keyPath, vn of @_nodes when not vn.isStable!
        return false
      true

  createNode: !(vinyl, errorHandler) ->
    const [keyPath, keyPathWithMin] = @_parseKeyPath vinyl.relative
    const fromNode = @_createNode keyPathWithMin || keyPath
    fromNode <<< {vinyl}
    fromNode._updateDependencies @

  updateNode: !(vinyl, errorHandler) ->
    const fromNode = @_findNodeAfterUpdated vinyl
    if fromNode
      fromNode <<< {vinyl}
    else
      errorHandler "[VinylNode.Collection] Can't update node (#{ vinyl.path })"

  finalizeNode: (vinyl, errorHandler) ->
    const fromNode = @_findNodeAfterUpdated vinyl
    if fromNode
      fromNode._isStable = true
      fromNode <<< {vinyl}
    else
      errorHandler "[VinylNode.Collection] Can't finalize node (#{ vinyl.path })"
    fromNode
}
/*
 * Private APIs
 */
prototype<<< {
  _parseKeyPath: (filepath) ->
    const [keyPath, firstExtname] = filepath.split '.'
    if 'min' is firstExtname
      [keyPath, "#{keyPath}__iLoveSprocket__min"]
    else
      [keyPath, void]

  _createNodeWith: (/* rawKeyPath */) ->
    const [keyPath, keyPathWithMin] = @_parseKeyPath it
    @_createNode keyPathWithMin || keyPath

  _createNode: (keyPath) ->
    @_nodes[keyPath] ||= new @constructor.Node keyPath

  _findNodeAfterUpdated: (vinyl) ->
    const [keyPath, keyPathWithMin] = @_parseKeyPath vinyl.relative
    if keyPathWithMin and @_nodes[keyPathWithMin]
      that
    else
      @_nodes[keyPath]
}
