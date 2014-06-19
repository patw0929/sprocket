var gulp = require('gulp');
var gulpJade = require('gulp-jade');
var gulpLivereload = require('gulp-livereload');
var Sprocket = require('sprocket');

var sprocket = Sprocket();
var PUBLIC_PATH = 'public/';
var ASSETS_PATH = '/assets/';
if (!sprocket.environment.isProduction) {
  PUBLIC_PATH = 'tmp/' + PUBLIC_PATH;
}

gulp.task('js', function () {
  return gulp.src([
    'client/javascripts/**/*.js',
    'client/javascripts/**/*.ls'
  ])
  .pipe(sprocket.createJavascriptsStream())
  .pipe(gulp.dest(PUBLIC_PATH+ASSETS_PATH));
});

gulp.task('css', function(){
  return gulp.src([
    'bower_components/bootstrap/less/bootstrap.less',
    'bower_components/bootstrap-sass-official/vendor/assets/stylesheets/bootstrap.scss',
    'client/stylesheets/*',
    'bower_components/**/*.css'
  ])
  .pipe(sprocket.createStylesheetsStream())
  .pipe(gulp.dest(PUBLIC_PATH+ASSETS_PATH));
});

gulp.task('html', ['js', 'css'], function(){
  var locals = sprocket.createViewHelpers({
    assetsPath: ASSETS_PATH
  });
  locals.pkg = require('./package.json');
  var stream = gulp.src('client/views/**/*.jade')
  .pipe(gulpJade({
    pretty: true,
    doctype: 'html',
    locals: locals
  }))
  .pipe(gulp.dest(PUBLIC_PATH));
  if (!sprocket.environment.isProduction) {
    stream = stream.pipe(gulpLivereload());
  }
  return stream;
});

gulp.task('server', ['html'], function(){
  gulp.watch(['client/**/*'], ['html']);
  require('./index');
});
