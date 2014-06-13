var through2;
through2 = require('through2');
module.exports = function(options){
  options || (options = {});
  function modifyFile(file, enc, done){
    this.push(file);
    done();
  }
  return through2.obj(modifyFile);
};