var PassThrough;
module.exports = PassThrough = (function(){
  PassThrough.displayName = 'PassThrough';
  var prototype = PassThrough.prototype, constructor = PassThrough;
  function PassThrough(_environment, _collection, _stream){
    this._environment = _environment;
    this._collection = _collection;
    this._stream = _stream;
  }
  prototype.process = function(){
    this._collection.vinyls.forEach(this._stream.push, this._stream);
  };
  return PassThrough;
}());