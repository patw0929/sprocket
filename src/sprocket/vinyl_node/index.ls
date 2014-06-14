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
  @_manifestFiles = {}

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
      #
      state[if isProduction then 'concatFile' else 'buildManifestFile'] do
        @_manifestFiles, vinyls, {
          keyPath
          isProduction
          extname: path.extname(node.vinyl.path)
        }

    Object.keys vinyls .map -> vinyls[it]

  getManifestContent: (options) ->
    @_manifestFiles[SprocketRequireState.getManifestFilepath options]
}
