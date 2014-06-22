module.exports = class

  !(@keyPath, @_collection) ->
    @_inRequireStates = [true]
    @_keyPaths = {}
    @_vinyls = []
    @_totalBufferSize = 0

  keyPaths:~
    -> @_keyPaths

  vinyls:~
    -> @_vinyls

  bufferWithSeperator: (seperator) ->
    new Buffer do
      @_totalBufferSize + @_vinyls.length * seperator.length

  buildDependenciesInState: (edge) ->
    @_inRequireStates.push edge.isRequireState
    try     edge._buildDependencies @
    finally @_inRequireStates.pop!

  needRequireOrInclude: (node) ->
    if @_inRequireStates[*-1]
      not @_keyPaths[node.keyPath]
    else
      #
      # include, so whatever do it
      #
      true

  addNodeIfNeeded: !(node) ->
    if @needRequireOrInclude node
      const {vinyl} = node
      @_keyPaths[node.keyPath] = true
      if vinyl.isBuffer!
        @_vinyls.push vinyl
        @_totalBufferSize += vinyl.contents.length
