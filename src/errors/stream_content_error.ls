require! {
  AddNodeError: './add_node_error'
}

module.exports = (keyPath) ->
  AddNodeError keyPath, "we currently doesn't support streaming files."
