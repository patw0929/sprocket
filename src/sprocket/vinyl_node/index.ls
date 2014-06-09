require! {
  util
  path
}
require! {
  Collection: '../../vinyl_node'
}
require! {
  SprocketRequireState: './require_state'
}

module.exports = SprocketCollection

util.inherits SprocketCollection, Collection
[SprocketCollection[k] = v for k, v of Collection]
SprocketCollection.RequireState = SprocketRequireState

!function SprocketCollection
  Collection ...

SprocketCollection::<<< {
  
  generateEntries: (isProduction) ->
    const vinyls = {}

    for keyPath, node of @_nodes when node.hasDependencies
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
