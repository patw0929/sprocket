module.exports = function(environment, src, dest){
  var gulpLess, options;
  gulpLess = require('gulp-less');
  options = {
    paths: environment.basePaths,
    compress: environment.minifyCSS
  };
  src.pipe(gulpLess(options)).pipe(dest);
};
