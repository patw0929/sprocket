var gulpSass;
gulpSass = require('gulp-sass');
module.exports = function(environment, src, dest){
  var options;
  options = {
    includePaths: environment.basePaths,
    outputStyle: environment.isProduction ? 'compressed' : 'nested'
  };
  src.pipe(gulpSass(options)).pipe(dest);
};