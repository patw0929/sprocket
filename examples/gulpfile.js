var gulp = require('gulp');
var gulpJade = require('gulp-jade');
var gulpLivereload = require('gulp-livereload');
var Sprocket;
try {
  // for development of sprocket, you could ignore it.
  Sprocket = require('LiveScript') && require('../src');
  console.log('Sprocket in development');
} catch (e) {
  Sprocket = require('sprocket');
}
/*
 * assign locals for views
 */
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
  return gulp.src([
    'bower_components/**/*.min.js',
    'client/javascripts/**/*.*'
  ])
  .pipe(environment.createJavascriptsStream())
  .pipe(gulp.dest(PUBLIC_PATH+ASSETS_PATH));
});

gulp.task('css', function(){
  return gulp.src([
    'bower_components/bootstrap/less/',
    'bower_components/bootstrap-sass-official/vendor/assets/stylesheets/',
    'client/stylesheets/*',
    'bower_components/**/*.css',
    '!bower_components/bootstrap/dist/**/*',
  ])
  .pipe(environment.createStylesheetsStream())
  .pipe(gulp.dest(PUBLIC_PATH+ASSETS_PATH));
});

gulp.task('html', ['js', 'css'], function(){
  return gulp.src('client/views/**/*.*')
  .pipe(environment.createHtmlsStream())
  .pipe(gulp.dest(PUBLIC_PATH));
});

gulp.task('server', ['html'], function(){
  gulp.watch(['client/**/*'], ['html']);
  gulp.watch([PUBLIC_PATH + '/**/*']).on('change', gulpLivereload.changed);
  gulpLivereload.listen();
  require('./index');
});
