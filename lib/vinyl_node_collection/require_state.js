module.exports = (function(){
  exports.displayName = 'exports';
  var prototype = exports.prototype, constructor = exports;
  function exports(keyPath, _collection){
    this.keyPath = keyPath;
    this._collection = _collection;
    this._inRequireStates = [true];
    this._keyPathAdded = {};
    this._pathsChanged = {};
    this._nothingChanged = true;
    this._vinyls = [];
    this._totalBufferSize = 0;
  }
  Object.defineProperty(prototype, 'pathsChanged', {
    get: function(){
      return this._pathsChanged;
    },
    configurable: true,
    enumerable: true
  });
  Object.defineProperty(prototype, 'nothingChanged', {
    get: function(){
      return this._nothingChanged;
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
    return new Buffer(this._totalBufferSize + this._vinyls.length * seperator.length);
  };
  prototype.buildDependenciesInState = function(edge){
    this._inRequireStates.push(edge.isRequireState);
    try {
      return edge._buildDependencies(this);
    } finally {
      this._inRequireStates.pop();
    }
  };
  prototype.needRequireOrInclude = function(node){
    var ref$;
    if ((ref$ = this._inRequireStates)[ref$.length - 1]) {
      return !this._keyPathAdded[node.keyPath];
    } else {
      return true;
    }
  };
  prototype.addNodeIfNeeded = function(node){
    var vinyl, justChanged, errorMessage;
    if (!this.needRequireOrInclude(node)) {
      return;
    }
    vinyl = node.vinyl, justChanged = node.justChanged;
    this._pathsChanged[vinyl.path] = justChanged;
    if (justChanged) {
      this._nothingChanged = false;
    }
    if (vinyl.isBuffer()) {
      this._keyPathAdded[node.keyPath] = true;
      this._vinyls.push(vinyl);
      this._totalBufferSize += vinyl.contents.length;
    } else {
      errorMessage = vinyl.isNull()
        ? "we can't find it in the files you passed in."
        : vinyl.isStream() ? "we currently doesn't support streaming files." : "some unknown file error happens.";
      errorMessage = "You require " + node.keyPath + " but " + errorMessage + "\nMake sure gulp.src did select the file you wants.";
      throw errorMessage;
    }
  };
  return exports;
}());