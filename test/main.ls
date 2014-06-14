require! {
  fs
  should
  mocha
  gutil: 'gulp-util'
  Sprocket: '../src'
}

(...) <-! describe 'sprocket'

it 'should compile livescript file to javascript' !(done) ->
  const ls = sprocket!
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