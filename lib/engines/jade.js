module.exports = function(environment, src, dest){
  var gulpJade, options;
  gulpJade = require('gulp-jade');
  options = {
    pretty: !environment.isProduction,
    locals: environment.viewLocals
  };
  src.pipe(gulpJade(options)).pipe(dest);
};