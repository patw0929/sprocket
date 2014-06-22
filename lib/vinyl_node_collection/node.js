var Edge, SuperNode, Node, DIRECTIVE_REGEX;
Edge = require('./edge');
SuperNode = require('./super_node');
Node = (function(){
  Node.displayName = 'Node';
  var prototype = Node.prototype, constructor = Node;
  function Node(keyPath){
    this.keyPath = keyPath;
    this._dependencies = '';
    this._edges = [];
    this._unstable = true;
    this._version = void 8;
    this._vinyl = void 8;
  }
  Object.defineProperty(prototype, 'hasAnyEdges', {
    get: function(){
      return this._edges.length > 0;
    },
    configurable: true,
    enumerable: true
  });
  Object.defineProperty(prototype, 'vinyl', {
    get: function(){
      return this._vinyl;
    },
    configurable: true,
    enumerable: true
  });
  prototype.isUnstable = function(collection){
    return this._unstable || this._version !== collection.version;
  };
  prototype.unstablize = function(collection, vinyl){
    var dependencies, stringified;
    dependencies = parseDependencies(vinyl.contents.toString());
    stringified = JSON.stringify(dependencies);
    if (stringified !== this._dependencies) {
      this._unstable = true;
      this._dependencies = stringified;
      this._vinyl = vinyl;
      this._edges = dependencies.map(function(it){
        return new (getEdgeCtor(it))(collection, this, it);
      }, this);
    }
  };
  prototype.stablize = function(collection, vinyl){
    this._unstable = false;
    this._version = collection.version;
    this._vinyl = vinyl;
  };
  prototype.pathMatches = function(regex){
    return this._vinyl.path.match(regex);
  };
  prototype.buildDependencies = function(state){
    if (state.needRequireOrInclude(this)) {
      this._edges.forEach(state.buildDependenciesInState, state);
      state.addNodeIfNeeded(this);
    }
    return state;
  };
  return Node;
}());
module.exports = Node;
/*
 * Private APIs
 */
DIRECTIVE_REGEX = /^.*=\s*(require|include)(_self|_directory|_tree)?(\s+([\w\.\/-]+))?$/gm;
function getEdgeCtor(dependency){
  switch (dependency.targetDirective) {
  case '_directory':
    return SuperNode.Directory;
  case '_tree':
    return SuperNode;
  case '_self':
    if (dependency.isRequireState) {
      return Edge.Circular;
    } else {
      return Edge;
    }
    break;
  default:
    return Edge;
  }
}
function parseDependencies(contents){
  var that, results$ = [];
  while (that = DIRECTIVE_REGEX.exec(contents)) {
    results$.push({
      isRequireState: 'require' === that[1],
      targetDirective: that[2],
      keyPath: that[4]
    });
  }
  return results$;
}