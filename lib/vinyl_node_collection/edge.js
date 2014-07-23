module.exports = Edge;
Edge.Circular = Circular;
function Edge(collection, fromNode, dependency){
  this.fromNode = fromNode;
  this.isRequireState = dependency.isRequireState;
  this.toNode = collection._createNodeWith(dependency.keyPath);
}
Edge.prototype._build_dependencies = function(state){
  this.toNode.build_dependencies(state);
};
function Circular(collection, fromNode, arg$){
  this.fromNode = fromNode;
  this.isRequireState = arg$.isRequireState;
  this.toNode = fromNode;
}
Circular.prototype._build_dependencies = function(state){
  state.include_node(this.toNode);
};