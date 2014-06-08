require! {
  util
  path
  File: vinyl
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
  @_count = 0
  @_stableCount = 0

const DIRECTIVE_REGEX = /^(.*=\s*(require|include|require_tree|include_tree)\s+([\w\.\/-]+))$/gm
const DIRECTIVE_TEST_REGEX = /^(require|include)(_tree)?$/

VinylNodeCollection::<<< {
  matchFilepath: (filepathMatcher, fromNode) ->
    const array = for keyPath, vn of @_nodes
      when vn.matchFilepath filepathMatcher and vn isnt fromNode
        vn
    array.sort (l, r) -> l.vinyl.path - r.vinyl.path

  _parseRelativeAndExtname: (relative) ->
    lastExtname = path.extname relative
    while lastExtname and '.min' isnt lastExtname
      relative.=replace new RegExp("#{ lastExtname }$"), ''
      lastExtname = path.extname relative
    [relative, lastExtname]

  _createNode: (keyPath) ->
    if @_nodes[keyPath]
      that
    else
      # console.log "insert path (#{ keyPath}) into nodes(#{ @_count})..."
      @_count++
      @_nodes[keyPath] = new VinylNode keyPath

  createNode: !(vinyl, errorHandler) ->
    const [relative, lastExtname] = @_parseRelativeAndExtname vinyl.relative
    @_updateNode @_createNode(relative), vinyl

  _updateNode: !(fromNode, vinyl) ->
    fromNode <<< {vinyl}
    if void is fromNode.dependencies 
      const contents = vinyl.contents.toString!

      fromNode.dependencies = while DIRECTIVE_REGEX.exec contents
        const [result, replacement, directive, keyPath] = that
        const directiveResult = directive.match DIRECTIVE_TEST_REGEX
        const Ctor = if '_tree' is directiveResult.2 then VinylSuperNode
                      else VinylNodeEdge
        new Ctor @, fromNode, 'require' is directiveResult.1, keyPath

    fromNode

  _checkIsMinified: !(vinyl, relative, lastExtname, errorHandler, methodName) ->
    #
    # Can't find node. Maybe it has been minified?
    const origRel = relative.replace new RegExp("#{ lastExtname }$"), ''
    # console.log 'Cant find ' relative, origRel, Object.keys(@_nodes)
    if '.min' is lastExtname and origRel of @_nodes
      # Okay
      @[methodName] @_nodes[origRel], vinyl
    else
      errorHandler "[VinylNodeCollection] Can't finalize node (#{ vinyl.path })"

  updateNode: !(vinyl, errorHandler) ->
    const [relative, lastExtname] = @_parseRelativeAndExtname vinyl.relative
    if @_nodes[relative]
      @_updateNode that, vinyl 
    else
      @_checkIsMinified vinyl, relative, lastExtname, errorHandler, '_updateNode'

  _finalizeNode: !(fromNode, vinyl) ->
    @_stableCount++
    @_updateNode fromNode, vinyl
    # console.log @_count, @_stableCount

  finalizeNode: !(vinyl, errorHandler) ->
    const [relative, lastExtname] = @_parseRelativeAndExtname vinyl.relative
    if @_nodes[relative]
      @_finalizeNode that, vinyl
    else
      @_checkIsMinified vinyl, relative, lastExtname, errorHandler, '_finalizeNode'

  isStable: -> @_stableCount is @_count

  generateEntries: ->
    const vinyls = {}

    for keyPath, node of @_nodes when node.canBeEntry!
      const state = new RequireState!
      node.toList state, @

      keyPath = path.join do
        path.dirname keyPath
        "#{ path.basename(keyPath) }#{
          path.extname(node.vinyl.path) 
        }.manifest.json"

      vinyls[keyPath] = new File do
        path: keyPath
        contents: new Buffer JSON.stringify state.dumpNodes!map (vn) ->
          const {vinyl} = vn
          vinyls[vn.keyPath] = vinyl
          vinyl.relative

    Object.keys vinyls .map -> vinyls[it]
}
