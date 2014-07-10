module.exports = class

  !(@keyPath, @_collection) ->
    @_inRequireStates = [true]
    @_keyPathAdded = {}
    @_pathsChanged = {}
    @_nothingChanged = true
    @_vinyls = []
    @_totalBufferSize = 0

  pathsChanged:~
    -> @_pathsChanged

  nothingChanged:~
    -> @_nothingChanged

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
      not @_keyPathAdded[node.keyPath]
    else
      #
      # include, so whatever do it
      #
      true

  addNodeIfNeeded: !(node) ->
    return unless @needRequireOrInclude node
    const {vinyl, justChanged} = node
    @_pathsChanged[vinyl.path] = justChanged
    @_nothingChanged = false if justChanged

    if vinyl.isBuffer!
      @_keyPathAdded[node.keyPath] = true
      @_vinyls.push vinyl
      @_totalBufferSize += vinyl.contents.length
    else
      errorMessage = if vinyl.isNull!
        "we can't find it in the files you passed in."
      else if vinyl.isStream!
        "we currently doesn't support streaming files."
      else
        "some unknown file error happens."
      errorMessage = """
You require #{ node.keyPath } but #{ errorMessage }
Make sure gulp.src did select the file you wants.
      """
      throw errorMessage
