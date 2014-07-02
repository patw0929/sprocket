module.exports = function(environment, src, dest){
  var gulpJshint, gulpFilter, gulpUglify, filter;
  gulpJshint = require('gulp-jshint');
  gulpFilter = require('gulp-filter');
  gulpUglify = require('gulp-uglify');
  filter = gulpFilter(['**/*.js', '!**/*.min.js']);
  src = src.pipe(filter).pipe(gulpJshint()).pipe(gulpJshint.reporter('default'));
  if (environment.isProduction) {
    src = src.pipe(gulpUglify());
  }
  src = src.pipe(filter.restore());
  src.pipe(dest);
};