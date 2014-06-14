var util, Node;
util = require('util');
Node = require('../../vinyl_node/node');
module.exports = SprocketNode;
util.inherits(SprocketNode, Node);
function SprocketNode(){
  Node.apply(this, arguments);
}
SprocketNode.prototype.isStable = function(collection){
  return Node.prototype.isStable.apply(this, arguments) && this._version === collection._version;
};