var util, path, Node, Edge, SuperNode, RequireState, prototype;
util = require('util');
path = require('path');
Node = require('./node');
Edge = require('./edge');
SuperNode = require('./super_node');
RequireState = require('./require_state');
module.exports = Collection;
Collection.RequireState = RequireState;
Collection.Node = Node;
Collection.Edge = Edge;
Collection.SuperNode = SuperNode;
function Collection(){
  this._nodes = {};
}
/*
 * Collection.prototype
 */
prototype = Collection.prototype;
/*
 * Public APIs
 */
Object.defineProperty(prototype, 'isStable', {
  get: function(){
    var keyPath, ref$, vn;
    for (keyPath in ref$ = this._nodes) {
      vn = ref$[keyPath];
      if (!vn.isStable()) {
        return false;
      }
    }
    return true;
  },
  configurable: true,
  enumerable: true
});
prototype.createNode = function(vinyl, errorHandler){
  var ref$, keyPath, keyPathWithMin, fromNode;
  ref$ = this._parseKeyPath(vinyl.relative), keyPath = ref$[0], keyPathWithMin = ref$[1];
  fromNode = this._createNode(keyPathWithMin || keyPath);
  fromNode.vinyl = vinyl;
  fromNode._updateDependencies(this);
};
prototype.updateNode = function(vinyl, errorHandler){
  var fromNode;
  fromNode = this._findNodeAfterUpdated(vinyl);
  if (fromNode) {
    fromNode.vinyl = vinyl;
  } else {
    errorHandler("[VinylNode.Collection] Can't update node (" + vinyl.path + ")");
  }
};
prototype.finalizeNode = function(vinyl, errorHandler){
  var fromNode;
  fromNode = this._findNodeAfterUpdated(vinyl);
  if (fromNode) {
    fromNode._isStable = true;
    fromNode.vinyl = vinyl;
  } else {
    errorHandler("[VinylNode.Collection] Can't finalize node (" + vinyl.path + ")");
  }
  return fromNode;
};
/*
 * Private APIs
 */
prototype._parseKeyPath = function(filepath){
  var ref$, keyPath, firstExtname;
  ref$ = filepath.split('.'), keyPath = ref$[0], firstExtname = ref$[1];
  if ('min' === firstExtname) {
    return [keyPath, keyPath + "__iLoveSprocket__min"];
  } else {
    return [keyPath, void 8];
  }
};
prototype._createNodeWith = function(it){
  var ref$, keyPath, keyPathWithMin;
  ref$ = this._parseKeyPath(it), keyPath = ref$[0], keyPathWithMin = ref$[1];
  return this._createNode(keyPathWithMin || keyPath);
};
prototype._createNode = function(keyPath){
  var ref$;
  return (ref$ = this._nodes)[keyPath] || (ref$[keyPath] = new this.constructor.Node(keyPath));
};
prototype._findNodeAfterUpdated = function(vinyl){
  var ref$, keyPath, keyPathWithMin, that;
  ref$ = this._parseKeyPath(vinyl.relative), keyPath = ref$[0], keyPathWithMin = ref$[1];
  if (that = keyPathWithMin && this._nodes[keyPathWithMin]) {
    return that;
  } else {
    return this._nodes[keyPath];
  }
};