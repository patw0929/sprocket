var gulpEjs;
gulpEjs = require('gulp-ejs');
module.exports = function(environment, src, dest){
  src.pipe(gulpEjs(environment.viewLocals)).pipe(dest);
};