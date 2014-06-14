module.exports = Edge;
Edge.Circular = Circular;
function Edge(collection, fromNode, options){
  this.fromNode = fromNode;
  this.isRequireState = options.isRequireState;
  this.toNode = collection._createNodeWith(options.keyPath);
}
Edge.prototype._buildDependencies = function(state, collection){
  this.toNode.buildDependencies(state, collection);
};
function Circular(collection, fromNode, options){
  this.fromNode = fromNode;
  this.isRequireState = options.isRequireState;
  this.toNode = fromNode;
}
Circular.prototype._buildDependencies = function(state, collection){
  var toNode;
  toNode = this.toNode;
  if (!state.requiredBefore(toNode.keyPath)) {
    state.addNode(toNode);
  }
};