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

  createNodeWith: (/* rawKeyPath */) ->
    const [keyPath, keyPathWithMin] = @_parseKeyPath it
    @_createNode keyPathWithMin || keyPath

  createNode: !(vinyl, errorHandler) ->
    const [keyPath, keyPathWithMin] = @_parseKeyPath vinyl.relative
    const fromNode = @_createNode keyPathWithMin || keyPath
    @_updateNode fromNode, vinyl

  updateNode: !(vinyl, errorHandler) ->
    const fromNode = @_findNodeAfterUpdated vinyl
    if fromNode
      @_updateNode fromNode, vinyl
    else
      errorHandler "[VinylNode.Collection] Can't update node (#{ vinyl.path })"

  finalizeNode: (vinyl, errorHandler) ->
    const fromNode = @_findNodeAfterUpdated vinyl
    if fromNode
      @_finalizeNode fromNode, vinyl
    else
      errorHandler "[VinylNode.Collection] Can't finalize node (#{ vinyl.path })"
    fromNode
}
/*
 * Private APIs
 */
const DIRECTIVE_REGEX = //^.*=\s*
  (require|include)
  (_self|_directory|_tree)
  ?(\s+([\w\.\/-]+))?$
//gm

function getEdgeCtor (constructor, targetDirective, isRequireState)
  switch targetDirective
  | '_directory' => return constructor.SuperNode.Directory
  | '_tree' => return constructor.SuperNode
  | '_self' =>
      return constructor.Edge.Circular if isRequireState
  constructor.Edge # default

prototype<<< {
  _parseKeyPath: (filepath) ->
    const [keyPath, firstExtname] = filepath.split '.'
    if 'min' is firstExtname
      [keyPath, "#{keyPath}__iLoveSprocket__min"]
    else
      [keyPath, void]

  _createNode: (keyPath) ->
    @_nodes[keyPath] ||= new @constructor.Node keyPath

  _updateNode: !(fromNode, vinyl) ->
    fromNode <<< {vinyl}
    return if fromNode.dependencies
    const contents = vinyl.contents.toString!
    #
    fromNode.dependencies = while DIRECTIVE_REGEX.exec contents
      const isRequireState = 'require' is that.1
      const Ctor = getEdgeCtor @constructor, that.2, isRequireState

      new Ctor fromNode, isRequireState, {
        collection: @
        keyPath: that.4
      }

  _findNodeAfterUpdated: !(vinyl) ->
    const relativePaths = [vinyl.relative]
    relativePaths.push path.relative(vinyl.base, that) if vinyl.revOrigPath
    #
    for filepath in relativePaths
      const [keyPath, keyPathWithMin] = @_parseKeyPath filepath
      const fromNode = if keyPathWithMin and @_nodes[keyPathWithMin]
        that
      else
        @_nodes[keyPath]
      return fromNode if fromNode

  _finalizeNode: !(fromNode, vinyl) ->
    fromNode._isStable = true
    @_updateNode fromNode, vinyl
}
