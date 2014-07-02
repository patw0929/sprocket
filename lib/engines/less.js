module.exports = function(environment, src, dest){
  var gulpLess, options;
  gulpLess = require('gulp-less');
  options = {
    paths: environment.basePaths,
    compress: environment.isProduction
  };
  src.pipe(gulpLess(options)).pipe(dest);
};