module.exports = function(environment, src, dest){
  var gulpEjs;
  gulpEjs = require('gulp-ejs');
  src.pipe(gulpEjs(environment.viewLocals)).pipe(dest);
};