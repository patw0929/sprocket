var mapStream, gutil;
mapStream = require('map-stream');
gutil = require('gulp-util');
module.exports = function(options){
  options || (options = {});
  function modifyFile(file, cb){
    cb(void 8, file);
  }
  return mapStream(modifyFile);
};