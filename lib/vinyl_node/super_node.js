var util, path, ref$;
util = require('util');
path = require('path');
module.exports = SuperNode;
SuperNode.Directory = Directory;
function BaseSuperNode(collection, fromNode, options){
  var keyPath;
  this.fromNode = fromNode;
  this.isRequireState = options.isRequireState, keyPath = options.keyPath;
  if ('.' === keyPath.charAt(0)) {
    return path.join(path.dirname(fromNode.path), keyPath, path.sep);
  } else {
    return keyPath;
  }
}
function pathSortFn(l, r){
  return l.path - r.path;
}
ref$ = BaseSuperNode.prototype;
ref$._buildDependencies = function(state, collection){
  this._filepathMatchedNodes(collection._nodes).sort(pathSortFn).forEach(function(it){
    it.buildDependencies(state, collection);
  });
};
ref$._filepathMatchedNodes = function(_nodes){
  var fromNode, _filepathMatcher, keyPath, vn, results$ = [];
  fromNode = this.fromNode, _filepathMatcher = this._filepathMatcher;
  for (keyPath in _nodes) {
    vn = _nodes[keyPath];
    if (vn !== fromNode && vn.path.match(_filepathMatcher)) {
      results$.push(vn);
    }
  }
  return results$;
};
util.inherits(SuperNode, BaseSuperNode);
function SuperNode(){
  var keyPath;
  keyPath = BaseSuperNode.apply(this, arguments);
  this._filepathMatcher = new RegExp("^" + keyPath);
}
util.inherits(Directory, BaseSuperNode);
function Directory(){
  var keyPath;
  keyPath = BaseSuperNode.apply(this, arguments);
  this._filepathMatcher = new RegExp("^" + keyPath + "((?!" + path.sep + ").)*$");
}