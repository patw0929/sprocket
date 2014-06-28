var gulpFilter, gulpMinifyCss;
gulpFilter = require('gulp-filter');
gulpMinifyCss = require('gulp-minify-css');
module.exports = function(environment, src, dest){
  var filter;
  if (environment.isProduction) {
    filter = gulpFilter(['**/*.css', '!**/*.min.css']);
    src = src.pipe(filter).pipe(gulpMinifyCss()).pipe(filter.restore());
  }
  src.pipe(dest);
};