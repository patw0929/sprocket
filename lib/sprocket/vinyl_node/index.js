var util, path, Collection, SprocketNode, SprocketRequireState, k, v, ref$;
util = require('util');
path = require('path');
Collection = require('../../vinyl_node');
SprocketNode = require('./node');
SprocketRequireState = require('./require_state');
module.exports = SprocketCollection;
util.inherits(SprocketCollection, Collection);
for (k in Collection) {
  v = Collection[k];
  SprocketCollection[k] = v;
}
SprocketCollection.RequireState = SprocketRequireState;
SprocketCollection.Node = SprocketNode;
function SprocketCollection(){
  Collection.apply(this, arguments);
  this._manifestFiles = {};
}
ref$ = SprocketCollection.prototype;
ref$.updateVersion = function(){
  this._version = Date.now();
};
ref$.finalizeNode = function(){
  var x$;
  x$ = Collection.prototype.finalizeNode.apply(this, arguments);
  x$._version = this._version;
  return x$;
};
Object.defineProperty(ref$, 'isStable', {
  get: function(){
    var keyPath, ref$, vn;
    for (keyPath in ref$ = this._nodes) {
      vn = ref$[keyPath];
      if (!vn.isStable(this)) {
        return false;
      }
    }
    return true;
  },
  configurable: true,
  enumerable: true
});
ref$.generateEntries = function(isProduction){
  var vinyls, keyPath, ref$, node, state;
  vinyls = {};
  for (keyPath in ref$ = this._nodes) {
    node = ref$[keyPath];
    if (node.hasAnyEdges) {
      state = new this.constructor.RequireState();
      node.buildDependencies(state, this);
      state[isProduction ? 'concatFile' : 'buildManifestFile'](this._manifestFiles, vinyls, {
        keyPath: keyPath,
        isProduction: isProduction,
        extname: path.extname(node.vinyl.path)
      });
    }
  }
  return Object.keys(vinyls).map(function(it){
    return vinyls[it];
  });
};
ref$.getManifestContent = function(options){
  return this._manifestFiles[SprocketRequireState.getManifestFilepath(options)];
};