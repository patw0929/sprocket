var util, Stream, Transform, ref$;
util = require('util');
Stream = require('stream');
module.exports = SprocketsTransform;
Transform = Stream.Transform;
util.inherits(SprocketsTransform, Transform);
function SprocketsTransform(arg){
  var options;
  if (!(this instanceof SprocketsTransform)) {
    return new SprocketsTransform(arg);
  }
  options = arguments[0] || (arguments[0] = {});
  options.objectMode = true;
  Transform.apply(this, arguments);
  this._boundedEndFn = Transform.prototype.end.bind(this);
  this._streamEnded = false;
  this.mimeType = options.mimeType;
  this._environment = options.environment;
  this._collection = options.collection;
  this._dispatchStartStream = options.dispatchStartStream;
}
ref$ = SprocketsTransform.prototype;
ref$._transform = function(file, enc, done){
  this._environment._addBasePath(file.base);
  this._collection.createNode(file, this);
  this._dispatchStartStream.write(file);
  done();
};
ref$.end = function(){
  this._streamEnded = true;
  this._endEventually();
};
ref$._endEventually = function(){
  if (!(this._streamEnded && this._collection.isStable)) {
    return;
  }
  if (!this._boundedEndFn) {
    return this.emit('error', 'Stream already ended!');
  }
  process.nextTick(this._boundedEndFn);
  this._boundedEndFn = void 8;
  this._environment._endStream(this);
  this._environment = this._collection = this._dispatchStartStream = void 8;
};