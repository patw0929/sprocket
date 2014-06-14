var Edge, SuperNode, prototype, DIRECTIVE_REGEX;
Edge = require('./edge');
SuperNode = require('./super_node');
module.exports = Node;
/*
 * Node
 */
function Node(keyPath){
  this.keyPath = keyPath;
  this.vinyl = void 8;
  this._dependencies = '';
  this._edges = [];
  this._isStable = false;
}
/*
 * Node.prototype
 */
prototype = Node.prototype;
prototype.isStable = function(){
  return this._isStable;
};
Object.defineProperty(prototype, 'path', {
  get: function(){
    return this.vinyl.path;
  },
  configurable: true,
  enumerable: true
});
Object.defineProperty(prototype, 'hasAnyEdges', {
  get: function(){
    return this._edges.length;
  },
  configurable: true,
  enumerable: true
});
prototype.buildDependencies = function(state, collection){
  if (state.requiredBefore(this.keyPath)) {
    return;
  }
  this._edges.forEach(function(it){
    it.buildDependencies(state, collection);
  });
  if (!state.requiredBefore(this.keyPath)) {
    state.addNode(this);
  }
};
/*
 * Private APIs
 */
DIRECTIVE_REGEX = /^.*=\s*(require|include)(_self|_directory|_tree)?(\s+([\w\.\/-]+))?$/gm;
function getEdgeCtor(collection, options){
  var constructor;
  constructor = collection.constructor;
  switch (options.targetDirective) {
  case '_directory':
    return constructor.SuperNode.Directory;
  case '_tree':
    return constructor.SuperNode;
  case '_self':
    if (options.isRequireState) {
      return constructor.Edge.Circular;
    }
  }
  return constructor.Edge;
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
prototype._updateDependencies = function(collection){
  var dependencies, stringified;
  dependencies = parseDependencies(this.vinyl.contents.toString());
  stringified = JSON.stringify(dependencies);
  if (stringified === this._dependencies) {
    return;
  }
  this._edges = dependencies.map(function(it){
    return new (getEdgeCtor(collection, it))(collection, this, it);
  }, this);
  this._dependencies = stringified;
  return this;
};
prototype._matchFilepath = function(superNode){
  return this.path.match(superNode._filepathMatcher);
};
Edge.prototype.buildDependencies = buildDependencies;
Edge.Circular.prototype.buildDependencies = buildDependencies;
SuperNode.prototype.buildDependencies = buildDependencies;
SuperNode.Directory.prototype.buildDependencies = buildDependencies;
function buildDependencies(state, collection){
  state.pushState(this.isRequireState);
  try {
    this._buildDependencies(state, collection);
  } finally {
    state.popState();
  }
}