var gulp = require('gulp');
var gulpJade = require('gulp-jade');
var gulpLivereload = require('gulp-livereload');
require('LiveScript');
var Sprocket = require('../src');
Sprocket.viewLocals.pkg = require('./package.json');
Sprocket.viewLocals.baseUrl = 'http://localhost:5000/';
Sprocket.viewLocals.bootstrapFontPath = 'http://netdna.bootstrapcdn.com/bootstrap/3.0.0/fonts/';

var environment = new Sprocket.Environment();
var PUBLIC_PATH = 'public/';
var ASSETS_PATH = '/assets/';
if (!environment.isProduction) {
  PUBLIC_PATH = 'tmp/' + PUBLIC_PATH;
}

gulp.task('js', function () {
  return gulp.src('client/javascripts/**/*.*')
  .pipe(environment.createJavascriptsStream())
  .pipe(gulp.dest(PUBLIC_PATH+ASSETS_PATH));
});

gulp.task('css', function(){
  return gulp.src([
    'bower_components/bootstrap/less/bootstrap.less',
    'bower_components/bootstrap-sass-official/vendor/assets/stylesheets/bootstrap.scss',
    'client/stylesheets/*',
    'bower_components/**/*.css'
  ])
  .pipe(environment.createStylesheetsStream())
  .pipe(gulp.dest(PUBLIC_PATH+ASSETS_PATH));
});

gulp.task('html', ['js', 'css'], function(){
  var stream = gulp.src('client/views/**/*.*')
  .pipe(environment.createHtmlsStream())
  .pipe(gulp.dest(PUBLIC_PATH));
  if (!environment.isProduction) {
    stream = stream.pipe(gulpLivereload());
  }
  return stream;
});

gulp.task('server', ['html'], function(){
  gulp.watch(['client/**/*'], ['html']);
  require('./index');
});
