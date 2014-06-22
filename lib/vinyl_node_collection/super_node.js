var util, path, SuperNode, Directory, prototype;
util = require('util');
path = require('path');
SuperNode = (function(){
  SuperNode.displayName = 'SuperNode';
  var prototype = SuperNode.prototype, constructor = SuperNode;
  function SuperNode(){
    var keyPath;
    keyPath = BaseSuperNode.apply(this, arguments);
    this._filepathMatcher = new RegExp("^" + keyPath);
  }
  return SuperNode;
}());
Directory = (function(){
  Directory.displayName = 'Directory';
  var prototype = Directory.prototype, constructor = Directory;
  function Directory(){
    var keyPath;
    keyPath = BaseSuperNode.apply(this, arguments);
    this._filepathMatcher = new RegExp("^" + keyPath + "((?!" + path.sep + ").)*$");
  }
  return Directory;
}());
SuperNode.Directory = Directory;
module.exports = SuperNode;
function BaseSuperNode(collection, fromNode, dependency){
  var keyPath;
  this.fromNode = fromNode;
  this.isRequireState = dependency.isRequireState, keyPath = dependency.keyPath;
  if ('.' === keyPath.charAt(0)) {
    return path.join(path.dirname(fromNode.vinyl.path), keyPath, path.sep);
  } else {
    return keyPath;
  }
}
function pathSortFn(l, r){
  return l.path - r.path;
}
prototype = {
  _buildDependencies: function(state){
    this._filepathMatchedNodes(state._collection._nodes).sort(pathSortFn).forEach(function(it){
      it.buildDependencies(state);
    });
  },
  _filepathMatchedNodes: function(_nodes){
    var fromNode, _filepathMatcher, keyPath, vn, results$ = [];
    fromNode = this.fromNode, _filepathMatcher = this._filepathMatcher;
    for (keyPath in _nodes) {
      vn = _nodes[keyPath];
      if (vn !== fromNode && vn.pathMatches(_filepathMatcher)) {
        results$.push(vn);
      }
    }
    return results$;
  }
};
import$(SuperNode.prototype, prototype);
import$(Directory.prototype, prototype);
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}