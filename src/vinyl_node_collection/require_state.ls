require! {
  AddNodeError: '../errors/add_node_error'
  NullFileError: '../errors/null_file_error'
  StreamContentError: '../errors/stream_content_error'
}

module.exports = class

  !(@keyPath, @_collection) ->
    @_in_require_states = [true]
    @_key_path_added = {}
    @_paths_changed = {}
    @_nothing_changed = true
    @_vinyls = []
    @_total_buffer_size = 0

  pathsChanged:~
    -> @_paths_changed

  nothingChanged:~
    -> @_nothing_changed

  vinyls:~
    -> @_vinyls

  bufferWithSeperator: (seperator) ->
    new Buffer do
      @_total_buffer_size + @_vinyls.length * seperator.length

  build_dependencies_in_state: (edge) ->
    @_in_require_states.push edge.isRequireState
    try     edge._build_dependencies @
    finally @_in_require_states.pop!

  should_include_node: (node) ->
    if @_in_require_states[*-1]
      not @_key_path_added[node.keyPath]
    else
      #
      # include, so whatever do it
      #
      true

  include_node: !(node) ->
    return unless @should_include_node node
    const {vinyl, justChanged} = node
    @_paths_changed[vinyl.path] = justChanged
    @_nothing_changed = false if justChanged

    if vinyl.isBuffer!
      @_key_path_added[node.keyPath] = true
      @_vinyls.push vinyl
      @_total_buffer_size += vinyl.contents.length
    else
      errorFn = if vinyl.isNull!
        NullFileError
      else if vinyl.isStream!
        StreamContentError
      else
        AddNodeError
      throw errorFn node.keyPath
