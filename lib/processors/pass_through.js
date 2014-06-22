var PassThrough;
module.exports = PassThrough = (function(){
  PassThrough.displayName = 'PassThrough';
  var prototype = PassThrough.prototype, constructor = PassThrough;
  function PassThrough(environment, collection, stream){
    this.environment = environment;
    this.collection = collection;
    this.stream = stream;
  }
  prototype.process = function(){
    this.collection.vinyls.forEach(this.stream.push, this.stream);
  };
  return PassThrough;
}());