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
  this._bounded_end_fn = Transform.prototype.end.bind(this);
  this._stream_has_ended = false;
  this._mime_type = options.mimeType;
  this._environment = options.environment;
  this._collection = options.collection;
  this._dispatch_start_stream = options.dispatchStartStream;
}
ref$ = SprocketsTransform.prototype;
Object.defineProperty(ref$, 'mimeType', {
  get: function(){
    return this._mime_type;
  },
  configurable: true,
  enumerable: true
});
ref$._transform = function(file, enc, done){
  if (file.isDirectory()) {
    this._environment.add_base_path(file.path);
  } else {
    this._environment.add_base_path(file.base);
    if (this._collection.createNode(file, this)) {
      this._dispatch_start_stream.write(file);
    }
  }
  done();
};
ref$.end = function(){
  this._stream_has_ended = true;
  this._endEventually();
};
ref$._endEventually = function(){
  if (!(this._stream_has_ended && this._collection.isStable)) {
    return;
  }
  if (!this._bounded_end_fn) {
    return this.emit('error', 'Stream already ended!');
  }
  process.nextTick(this._bounded_end_fn);
  this._bounded_end_fn = void 8;
  this._environment.end_stream(this);
  this._environment = this._collection = this._dispatch_start_stream = void 8;
};