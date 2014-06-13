require! {
  util
  path
}
require! {
  Collection: '../../vinyl_node'
}
require! {
  SprocketNode: './node'
  SprocketRequireState: './require_state'
}

module.exports = SprocketCollection

util.inherits SprocketCollection, Collection
[SprocketCollection[k] = v for k, v of Collection]
SprocketCollection.RequireState = SprocketRequireState
SprocketCollection.Node = SprocketNode

!function SprocketCollection
  Collection ...

SprocketCollection::<<< {
  updateVersion: !-> @_version = Date.now!

  finalizeNode: ->
    Collection::finalizeNode ...
      .._version = @_version

  isStable:~
    ->
      for keyPath, vn of @_nodes when not vn.isStable @
        return false
      true
  
  generateEntries: (isProduction) ->
    const vinyls = {}

    for keyPath, node of @_nodes when node.hasAnyEdges
      const state = new @constructor.RequireState!
      node.buildDependencies state, @
      const baseAndExtnames = SprocketRequireState.keyPath2BaseAndExtnames {
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
