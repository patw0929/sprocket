require! {
  path
}
require! {
  Edge: './edge'
  SuperNode: './super_node'
}

module.exports = Node
/*
 * Node
 */
!function Node (@keyPath)
  @vinyl = @_dependencies = @_edges = void
  @_isStable = false
/*
 * Node.prototype
 */
const {prototype} = Node
prototype<<< {
  isStable: -> @_isStable

  hasDependencies:~
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

prototype<<< {
  _parseDependencies: ->
    const contents = @vinyl.contents.toString!
    #
    while DIRECTIVE_REGEX.exec contents
      isRequireState: 'require' is that.1
      targetDirective: that.2
      keyPath: that.4

  _updateVinyl: !(vinyl) -> @ <<< {vinyl}

  _updateDependencies: !(collection) ->
    const dependencies = @_parseDependencies @vinyl.contents.toString!
    return if JSON.stringify(dependencies) is JSON.stringify(@_dependencies)
    #
    @_dependencies = dependencies
    @_edges = dependencies.map ->
      new (getEdgeCtor collection, it) collection, @, it
    , @

  _filepathFrom: (keyPath) ->
    path.join do
      path.dirname @vinyl.path
      keyPath
      path.sep

  _matchFilepath: (superNode) ->
    @vinyl.path.match superNode._filepathMatcher
}

Edge::<<< {buildDependencies}
Edge.Circular::<<< {buildDependencies}
SuperNode::<<< {buildDependencies}
SuperNode.Directory::<<< {buildDependencies}

!function buildDependencies (state, collection)
  state.pushState @isRequireState
  try     @_buildDependencies state, collection
  finally state.popState!
