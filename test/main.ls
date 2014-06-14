require! {
  fs
  path
  should
  mocha
  gulp
  gutil: 'gulp-util'
  Sprocket: '../src'
}

(...) <-! describe 'sprocket'

it 'should compile livescript file to javascript' !(done) ->
  @timeout 5000
  const sprocket = Sprocket!

  gulp.src <[
    examples/client/javascripts/**/*.js
    examples/client/javascripts/**/*.ls
  ]>
  .pipe sprocket.createJavascriptsStream!
  .on 'data' !(expectedFile) ->
    const basename = path.basename expectedFile.path
    return unless 'application-manifest.js.json' is basename

    JSON.stringify([
      "utils.js",
      "controllers/FooterCtrl.js",
      "models/User.js",
      "controllers/NavCtrl.js",
      "application.js"
    ], null, 2).should.equal expectedFile.contents.toString!
    done!
