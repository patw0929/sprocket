var gulp = require('gulp');
var Sprocket = require('sprocket');

var sprocket = Sprocket();

gulp.task('js', function () {
  return gulp.src([
    'client/javascripts/**/*.js',
    'client/javascripts/**/*.ls'
  ])
  .pipe(sprocket.createJavascriptsStream())
  .pipe(gulp.dest('tmp/public/assets'));
});
