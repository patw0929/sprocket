module.exports = function(keyPath, message){
  var error;
  message || (message = "some unknown file error happens.");
  error = Error("You require " + keyPath + " but " + message + "\nMake sure gulp.src did select the file you wants.");
  error.keyPath = keyPath;
  return error;
};