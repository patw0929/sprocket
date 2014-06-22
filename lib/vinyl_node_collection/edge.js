module.exports = Edge;
Edge.Circular = Circular;
function Edge(collection, fromNode, dependency){
  this.fromNode = fromNode;
  this.isRequireState = dependency.isRequireState;
  this.toNode = collection._createNodeWith(dependency.keyPath);
}
Edge.prototype._buildDependencies = function(state){
  this.toNode.buildDependencies(state);
};
function Circular(collection, fromNode, arg$){
  this.fromNode = fromNode;
  this.isRequireState = arg$.isRequireState;
  this.toNode = fromNode;
}
Circular.prototype._buildDependencies = function(state){
  state.addNodeIfNeeded(this.toNode);
};