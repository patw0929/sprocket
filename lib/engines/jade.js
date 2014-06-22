var gulpJade;
gulpJade = require('gulp-jade');
module.exports = function(environment, src, dest){
  var options;
  options = {
    pretty: !environment.isProduction,
    locals: environment.viewLocals
  };
  src.pipe(gulpJade(options)).pipe(dest);
};