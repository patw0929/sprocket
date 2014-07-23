module.exports = function(keyPath){
  var error;
  error = Error("" + keyPath + " must contain at least one sprocket directive.\nIf it requires no extra dependency, just put a `require_self` directive.\nSee https://github.com/tomchentw/sprocket/issues/11\nfor more details.");
  error.keyPath = keyPath;
  return error;
};