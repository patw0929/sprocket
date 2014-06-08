require! {
  util
  path
}
require! {
  VinylNodeEdge: './vinyl_node_edge'
  VinylSuperNode: './vinyl_super_node'
  VinylNode: './vinyl_node'
  RequireState: './require_state'
}

module.exports = VinylNodeCollection

!function VinylNodeCollection
  @_nodes = {}
/*
 * VinylNodeCollection.prototype
 */
const {prototype} = VinylNodeCollection
/*
 * Public APIs
 */
prototype <<< {
  isStable:~
    ->
      for keyPath, vn of @_nodes when not vn.isStable
        return false
      true

  matchFilepath: (filepathMatcher, fromNode) ->
    const array = for keyPath, vn of @_nodes
      when vn.matchFilepath filepathMatcher and vn isnt fromNode
        vn
    array.sort (l, r) -> l.vinyl.path - r.vinyl.path

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
      errorHandler "[VinylNodeCollection] Can't update node (#{ vinyl.path })"

  finalizeNode: !(vinyl, errorHandler) ->
    const fromNode = @_findNodeAfterUpdated vinyl
    if fromNode
      @_finalizeNode fromNode, vinyl
    else
      errorHandler "[VinylNodeCollection] Can't finalize node (#{ vinyl.path })"

  generateEntries: (isProduction) ->
    const vinyls = {}

    for keyPath, node of @_nodes when node.canBeEntry!
      const state = new RequireState!
      node.buildDependencies state, @
      const baseAndExtnames = RequireState.keyPath2BaseAndExtnames {
        keyPath
        isProduction
        extname: path.extname(node.vinyl.path)
      }

      if isProduction
        state.concatFile vinyls, baseAndExtnames
      else
        state.buildManifestFile vinyls, baseAndExtnames
    Object.keys vinyls .map -> vinyls[it]
}
/*
 * Private APIs
 */
const DIRECTIVE_REGEX = /^(.*=\s*(require|include|require_tree|include_tree)\s+([\w\.\/-]+))$/gm
const DIRECTIVE_TEST_REGEX = /^(require|include)(_tree)?$/

prototype<<< {
  _parseKeyPath: (filepath) ->
    const [keyPath, firstExtname] = filepath.split '.'
    if 'min' is firstExtname
      [keyPath, "#{keyPath}__iLoveSprocket__min"]
    else
      [keyPath, void]

  _createNode: (keyPath) ->
    if @_nodes[keyPath]
      that
    else
      # console.log "insert path (#{ keyPath}) into nodes(#{ @_count})..."
      @_nodes[keyPath] = new VinylNode keyPath

  _updateNode: !(fromNode, vinyl) ->
    fromNode <<< {vinyl}
    return if fromNode.dependencies 
    #
    const contents = vinyl.contents.toString!

    fromNode.dependencies = while DIRECTIVE_REGEX.exec contents
      const [result, replacement, directive, keyPath] = that
      const directiveResult = directive.match DIRECTIVE_TEST_REGEX
      const Ctor = if '_tree' is directiveResult.2 then VinylSuperNode
                    else VinylNodeEdge
      new Ctor @, fromNode, 'require' is directiveResult.1, keyPath

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
    fromNode.isStable = true
    @_updateNode fromNode, vinyl
    # console.log @_count, @_stableCount
}
