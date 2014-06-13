require! {
  Edge: './edge'
  SuperNode: './super_node'
}

module.exports = Node
/*
 * Node
 */
!function Node (@keyPath)
  @vinyl = void
  #
  # private properties
  #
  @_dependencies = ''
  @_edges = []
  @_isStable = false
/*
 * Node.prototype
 */
const {prototype} = Node
prototype<<< {
  isStable: -> @_isStable

  path:~
    -> @vinyl.path

  hasAnyEdges:~
    -> @_edges.length

  buildDependencies: !(state, collection) ->
    return if state.requiredBefore @keyPath
    @_edges.forEach !-> it.buildDependencies state, collection
    state.addNode @ unless state.requiredBefore @keyPath
}
/*
 * Private APIs
 */
const DIRECTIVE_REGEX = //^.*=\s*
  (require|include)
  (_self|_directory|_tree)
  ?(\s+([\w\.\/-]+))?$
//gm

function getEdgeCtor (collection, options)
  const {constructor} = collection
  switch options.targetDirective
  | '_directory' => return constructor.SuperNode.Directory
  | '_tree' => return constructor.SuperNode
  | '_self' =>
      return constructor.Edge.Circular if options.isRequireState
  constructor.Edge # default

function parseDependencies (contents)
  while DIRECTIVE_REGEX.exec contents
    isRequireState: 'require' is that.1
    targetDirective: that.2
    keyPath: that.4

prototype<<< {

  _updateDependencies: (collection) ->
    const dependencies = parseDependencies @vinyl.contents.toString!
    const stringified = JSON.stringify dependencies
    return if stringified is @_dependencies
    #
    @_edges = dependencies.map ->
      new (getEdgeCtor collection, it) collection, @, it
    , @
    @_dependencies = stringified
    @

  _matchFilepath: (superNode) ->
    @path.match superNode._filepathMatcher
}

Edge::<<< {buildDependencies}
Edge.Circular::<<< {buildDependencies}
SuperNode::<<< {buildDependencies}
SuperNode.Directory::<<< {buildDependencies}

!function buildDependencies (state, collection)
  state.pushState @isRequireState
  try     @_buildDependencies state, collection
  finally state.popState!
