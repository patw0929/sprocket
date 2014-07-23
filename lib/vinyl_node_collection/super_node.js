var util, path, SuperNode, Directory, prototype;
util = require('util');
path = require('path');
SuperNode = (function(){
  SuperNode.displayName = 'SuperNode';
  var prototype = SuperNode.prototype, constructor = SuperNode;
  function SuperNode(){
    var keyPath;
    keyPath = BaseSuperNode.apply(this, arguments);
    this._filepath_matcher = new RegExp("^" + keyPath);
  }
  return SuperNode;
}());
Directory = (function(){
  Directory.displayName = 'Directory';
  var prototype = Directory.prototype, constructor = Directory;
  function Directory(){
    var keyPath;
    keyPath = BaseSuperNode.apply(this, arguments);
    this._filepath_matcher = new RegExp("^" + keyPath + "((?!" + path.sep + ").)*$");
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
    return fromNode.resolve_key_path(keyPath);
  } else {
    return keyPath;
  }
}
function pathSortFn(l, r){
  return l.path - r.path;
}
prototype = {
  _build_dependencies: function(state){
    this._nodes_match_filepath(state._collection._nodes).sort(pathSortFn).forEach(function(it){
      it.build_dependencies(state);
    });
  },
  _nodes_match_filepath: function(_nodes){
    var fromNode, _filepath_matcher, keyPath, vn, results$ = [];
    fromNode = this.fromNode, _filepath_matcher = this._filepath_matcher;
    for (keyPath in _nodes) {
      vn = _nodes[keyPath];
      if (vn !== fromNode && vn.path_matches(_filepath_matcher)) {
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