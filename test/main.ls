require! {
  fs
  path
  should
  mocha
  gulp
  gutil: 'gulp-util'
}

const Sprocket = require if process.env.TRAVIS then '../lib' else '../src'

(...) <-! describe 'Environment'

it 'should generate correct manifest json based on dependencies' !(done) ->
  @timeout 5000
  Sprocket.viewLocals.baseUrl = 'http://test/'
  const environment = new Sprocket.Environment!

  gulp.src 'examples/client/javascripts/**/*.*'
  .pipe environment.createJavascriptsStream!
  .on 'data' !(expectedFile) ->
    const basename = path.basename expectedFile.path
    return unless 'application-manifest.js.json' is basename

    (err, data) <-! fs.readFile 'test/fixtures/application-manifest.js.json', 'utf8'
    String expectedFile.contents .should.equal data
    done!
