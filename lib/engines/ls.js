module.exports = function(environment, src, dest){
  var gulpLivescript;
  gulpLivescript = require('gulp-livescript');
  src.pipe(gulpLivescript()).pipe(dest);
};