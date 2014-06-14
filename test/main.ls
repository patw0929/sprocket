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

it 'should generate correct manifest json based on dependencies' !(done) ->
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

    (err, data) <-! fs.readFile 'test/fixtures/application-manifest.js.json', 'utf8'
    String expectedFile.contents .should.equal data
    done!
