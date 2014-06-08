require! {
  'map-stream'
  gutil: 'gulp-util'
}

module.exports = (options || {}) -> 
  !function modifyFile (file, cb)
    cb void, file

  map-stream modifyFile