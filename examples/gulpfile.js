var gulp = require('gulp');
var Sprocket = require('sprocket');

var sprocket = Sprocket();

gulp.task('js', function () {
  return gulp.src([
    'examples/client/javascripts/**/*.js',
    'examples/client/javascripts/**/*.ls'
  ]).pipe(sprocket.createJavascriptsStream())
  .pipe(gulp.dest('examples/tmp/assets'));
});
