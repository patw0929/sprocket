require! {
  Edge: './edge'
  SuperNode: './super_node'
}

class Node

  !(@keyPath) ->
    @_dependencies = ''
    @_edges = []
    @_unstable = true
    @_version = void
    @_vinyl = void

  hasAnyEdges:~
    -> @_edges.length > 0

  vinyl:~
    -> @_vinyl

  isUnstable: (collection) ->
    @_unstable || @_version isnt collection.version

  unstablize: !(collection, vinyl) ->
    const dependencies = parseDependencies vinyl.contents.toString!
    const stringified = JSON.stringify dependencies
    if stringified isnt @_dependencies
      @_unstable = true
      @_dependencies = stringified
      @_vinyl = vinyl
      @_edges = dependencies.map ->
        new (getEdgeCtor it)(collection, @, it)
      , @

  stablize: !(collection, vinyl) ->
    @_unstable = false
    @_version = collection.version
    @_vinyl = vinyl

  pathMatches: (regex) ->
    @_vinyl.path.match regex
  
  buildDependencies: (state) ->
    if state.needRequireOrInclude @
      @_edges.forEach state.buildDependenciesInState, state
      #
      # add self to the end if it's not circular referred
      #
      state.addNodeIfNeeded @
    state

module.exports = Node
/*
 * Private APIs
 */
const DIRECTIVE_REGEX = //^.*=\s*
  (require|include)
  (_self|_directory|_tree)
  ?(\s+([\w\.\/-]+))?$
//gm

function getEdgeCtor (dependency)
  switch dependency.targetDirective
  | '_directory' => SuperNode.Directory
  | '_tree' => SuperNode
  | '_self' =>
      if dependency.isRequireState then Edge.Circular else Edge
  | _ => Edge
#
# Returns array of dependencies
# [{
#   isRequireState: true or false
#   targetDirective: '', '_tree', '_self', '_directory'  
#   keyPath: 'logical/path/to/assets'
# }]
#
function parseDependencies (contents)
  while DIRECTIVE_REGEX.exec contents
    isRequireState: 'require' is that.1
    targetDirective: that.2
    keyPath: that.4
