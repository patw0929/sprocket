require! {
  path
  crypto
  File: vinyl
}
require! {
  Edge: './edge'
  SuperNode: './super_node'
}

class Node
  @_null_file = new File!

  !(@keyPath) ->
    @_cached_deps = ''
    @_cached_hash = void
    @_unstable = false
    # Make all Nodes default to stable and only be unstable when tryUnstablize
    # successes. This can let us find out the missing node that doens't go
    # through the state from tryUnstablize to stablize
    @_src_path = void
    @_dest_vinyl = @@_null_file
    @_just_changed = true
    @_edges = []

  hasAnyEdges:~
    -> @_edges.length > 0

  vinyl:~
    -> @_dest_vinyl

  isUnstable:~
    -> @_unstable

  justChanged:~
    -> @_just_changed

  /*
   * Returns false if it cannot unstablize (the content isn't changed!)
   */
  tryUnstablize: (collection, vinyl) ->
    const contents  = vinyl.contents.toString!
    const newHash   = crypto.createHash 'sha1' .update contents .digest 'hex'
    @_unstable      = newHash isnt @_cached_hash

    if @_unstable
      @_cached_hash = newHash
      @_src_path    = vinyl.path

      const dependencies  = parseDependencies contents
      @_cached_deps = JSON.stringify dependencies
      @_edges = dependencies.map ->
        new (getEdgeCtor it)(collection, @, it)
      , @
    else
      @_just_changed = false
    @_unstable

  stablize: !(vinyl) ->
    @_unstable = false
    @_dest_vinyl = vinyl
    @_just_changed = true

  _resolveKeyPath: (keyPath) ->
    path.join path.dirname(@_src_path), keyPath, path.sep

  pathMatches: (regex) ->
    @_src_path.match regex
  
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
