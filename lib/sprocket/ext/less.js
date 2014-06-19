var gulpLess;
gulpLess = require('gulp-less');
module.exports = function(environment, src, dest){
  var options;
  options = {
    paths: environment.basePaths,
    compress: environment.isProduction
  };
  src.pipe(gulpLess(options)).pipe(dest);
};