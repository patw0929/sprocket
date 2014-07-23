module.exports = function(keyPath, filepath){
  var error;
  error = Error("Can't finalize node " + keyPath + " from file (" + filepath + ").");
  error.keyPath = keyPath;
  error.filepath = filepath;
  return error;
};