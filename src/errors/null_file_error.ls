require! {
  AddNodeError: './add_node_error'
}

module.exports = (keyPath) ->
  AddNodeError keyPath, "we can't find it in the files you passed in."
