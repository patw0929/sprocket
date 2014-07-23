var AddNodeError, NullFileError, StreamContentError;
AddNodeError = require('../errors/add_node_error');
NullFileError = require('../errors/null_file_error');
StreamContentError = require('../errors/stream_content_error');
module.exports = (function(){
  exports.displayName = 'exports';
  var prototype = exports.prototype, constructor = exports;
  function exports(keyPath, _collection){
    this.keyPath = keyPath;
    this._collection = _collection;
    this._in_require_states = [true];
    this._key_path_added = {};
    this._paths_changed = {};
    this._nothing_changed = true;
    this._vinyls = [];
    this._total_buffer_size = 0;
  }
  Object.defineProperty(prototype, 'pathsChanged', {
    get: function(){
      return this._paths_changed;
    },
    configurable: true,
    enumerable: true
  });
  Object.defineProperty(prototype, 'nothingChanged', {
    get: function(){
      return this._nothing_changed;
    },
    configurable: true,
    enumerable: true
  });
  Object.defineProperty(prototype, 'vinyls', {
    get: function(){
      return this._vinyls;
    },
    configurable: true,
    enumerable: true
  });
  prototype.bufferWithSeperator = function(seperator){
    return new Buffer(this._total_buffer_size + this._vinyls.length * seperator.length);
  };
  prototype.build_dependencies_in_state = function(edge){
    this._in_require_states.push(edge.isRequireState);
    try {
      return edge._build_dependencies(this);
    } finally {
      this._in_require_states.pop();
    }
  };
  prototype.should_include_node = function(node){
    var ref$;
    if ((ref$ = this._in_require_states)[ref$.length - 1]) {
      return !this._key_path_added[node.keyPath];
    } else {
      return true;
    }
  };
  prototype.include_node = function(node){
    var vinyl, justChanged, errorFn;
    if (!this.should_include_node(node)) {
      return;
    }
    vinyl = node.vinyl, justChanged = node.justChanged;
    this._paths_changed[vinyl.path] = justChanged;
    if (justChanged) {
      this._nothing_changed = false;
    }
    if (vinyl.isBuffer()) {
      this._key_path_added[node.keyPath] = true;
      this._vinyls.push(vinyl);
      this._total_buffer_size += vinyl.contents.length;
    } else {
      errorFn = vinyl.isNull()
        ? NullFileError
        : vinyl.isStream() ? StreamContentError : AddNodeError;
      throw errorFn(node.keyPath);
    }
  };
  return exports;
}());