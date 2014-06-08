require! {
  gulp
  'gulp-livescript'
  'gulp-bump'
  'gulp-conventional-changelog'
}
/*
 *
 * Define public interfaces for Makefile
 *
 */
gulp.task 'release' <[ build bump ]> ->
  return gulp.src <[ package.json CHANGELOG.md ]>
  .pipe gulp-conventional-changelog!
  .pipe gulp.dest '.'
/*
 *
 * Private support tasks, don't directly run them through cli
 *
 */
gulp.task 'build' ->
  return gulp.src 'src/**/*.ls'
  .pipe gulp-livescript bare: true
  .pipe gulp.dest 'lib'

gulp.task 'bump' ->
  return gulp.src 'package.json'
  .pipe gulp-bump process.env{TYPE or 'patch'}
  .pipe gulp.dest '.'
