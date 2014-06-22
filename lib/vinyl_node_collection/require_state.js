module.exports = (function(){
  exports.displayName = 'exports';
  var prototype = exports.prototype, constructor = exports;
  function exports(keyPath, _collection){
    this.keyPath = keyPath;
    this._collection = _collection;
    this._inRequireStates = [true];
    this._keyPaths = {};
    this._vinyls = [];
    this._totalBufferSize = 0;
  }
  Object.defineProperty(prototype, 'keyPaths', {
    get: function(){
      return this._keyPaths;
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
      return !this._keyPaths[node.keyPath];
    } else {
      return true;
    }
  };
  prototype.addNodeIfNeeded = function(node){
    var vinyl;
    if (this.needRequireOrInclude(node)) {
      vinyl = node.vinyl;
      this._keyPaths[node.keyPath] = true;
      if (vinyl.isBuffer()) {
        this._vinyls.push(vinyl);
        this._totalBufferSize += vinyl.contents.length;
      }
    }
  };
  return exports;
}());