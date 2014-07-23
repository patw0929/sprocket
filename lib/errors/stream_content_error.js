var AddNodeError;
AddNodeError = require('./add_node_error');
module.exports = function(keyPath){
  return AddNodeError(keyPath, "we currently doesn't support streaming files.");
};