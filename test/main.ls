require! {
  fs
  gutil: 'gulp-util'
  'gulp-sprocket': '../src'
  should
  mocha
}

(...) <-! describe 'gulp-sprocket'

it 'should compile livescript file to javascript' !(done) ->
  const ls = gulp-sprocket!
  const fakeFile = new gutil.File do
      base: 'test/fixtures'
      cwd: 'test/fixtures'
      path: 'test/fixtures/file.ls'
      contents: fs.readFileSync 'test/fixtures/file.ls'

  ls.once 'data' !(expectedFile) ->
    should.exist expectedFile
    should.exist expectedFile.path
    should.exist expectedFile.contents 
    String expectedFile.contents .should.equal fs.readFileSync('test/fixtures/file.ls', 'utf8')
    done!

  ls.write fakeFile