var gulpJshint, gulpFilter, gulpUglify;
gulpJshint = require('gulp-jshint');
gulpFilter = require('gulp-filter');
gulpUglify = require('gulp-uglify');
module.exports = function(environment, src, dest){
  var filter;
  filter = gulpFilter('!**/*.min.js');
  src = src.pipe(filter).pipe(gulpJshint()).pipe(gulpJshint.reporter('default'));
  if (environment.isProduction) {
    src = src.pipe(gulpUglify());
  }
  src = src.pipe(filter.restore());
  src.pipe(dest);
};