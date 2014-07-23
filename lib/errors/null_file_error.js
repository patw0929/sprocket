var AddNodeError;
AddNodeError = require('./add_node_error');
module.exports = function(keyPath){
  return AddNodeError(keyPath, "we can't find it in the files you passed in.");
};