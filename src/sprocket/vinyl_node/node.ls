require! {
  util
}
require! {
  Node: '../../vinyl_node/node'
}

module.exports = SprocketNode

util.inherits SprocketNode, Node
!function SprocketNode
  Node ...

SprocketNode::<<< {
  isStable: (collection) ->
    Node.prototype.isStable ... and @_version is collection._version
}

