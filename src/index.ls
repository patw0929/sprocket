require! {
  through2
}

module.exports = (options || {}) -> 
  !function modifyFile (file, enc, done)
    @push file
    done!

  through2.obj modifyFile
