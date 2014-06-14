var gulpLivescript;
gulpLivescript = require('gulp-livescript');
module.exports = function(environment, src, dest){
  src.pipe(gulpLivescript()).pipe(dest);
};