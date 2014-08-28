module.exports = function(environment, src, dest){
  var gulpSass, options;
  gulpSass = require('gulp-sass');
  options = {
    includePaths: environment.basePaths,
    outputStyle: environment.minifyCSS ? 'compressed' : 'nested'
  };
  src.pipe(gulpSass(options)).pipe(dest);
};
