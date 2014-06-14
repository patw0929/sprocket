var util, path, stream, Transform, PassThrough, ref$;
util = require('util');
path = require('path');
stream = require('stream');
Transform = stream.Transform, PassThrough = stream.PassThrough;
module.exports = SprocketStream;
/*
 * SprocketStream
 */
util.inherits(SprocketStream, Transform);
function SprocketStream(options){
  if (!(this instanceof SprocketStream)) {
    return new SprocketStream(options);
  }
  options || (options = {});
  options.objectMode = true;
  Transform.call(this, options);
  this._endWhenStablize = Transform.prototype.end.bind(this);
  this._endCalled = false;
  this._emitErrorInternal = this.emit.bind(this, 'error');
  this._environment = options.environment;
  this._nodeCollection = options.collection;
  this._nodeCollection.updateVersion();
  createInternalStreams(this, options.extname, options.extensions || {});
}
ref$ = SprocketStream.prototype;
ref$._dispatchInternal = function(file){
  this._internalStreams[path.extname(file.path)].write(file);
};
ref$._transform = function(file, _, done){
  this._environment.addBasePath(file.base);
  this._nodeCollection.createNode(file, this._emitErrorInternal);
  this._dispatchInternal(file);
  done();
};
ref$.end = function(){
  this._endCalled = true;
  this._end();
};
ref$._end = function(){
  if (!(this._endCalled && this._nodeCollection.isStable)) {
    return;
  }
  if (!this._endWhenStablize) {
    return this._emitErrorInternal('[SprocketStream] Already ended');
  }
  process.nextTick(this._endWhenStablize);
  this._endWhenStablize = void 8;
  this._nodeCollection.generateEntries(this._environment.isProduction).forEach(this.push, this);
};
/*
 * Helpers
 */
function createInternalStreams(stream, targetExtname, extensions){
  var _internalStreams, _dispatchEndStream, _targetEndStream, extname, configureFn, passThrough;
  _internalStreams = stream._internalStreams = {};
  _dispatchEndStream = new Transform({
    objectMode: true
  });
  _dispatchEndStream._transform = function(file, _, done){
    stream._nodeCollection.updateNode(file, stream._emitErrorInternal);
    stream._dispatchInternal(file);
    done();
  };
  _targetEndStream = new Transform({
    objectMode: true
  });
  _targetEndStream._transform = function(file, _, done){
    stream._nodeCollection.finalizeNode(file, stream._emitErrorInternal);
    stream._end();
    done();
  };
  for (extname in extensions) {
    configureFn = extensions[extname];
    passThrough = new PassThrough({
      objectMode: true
    });
    _internalStreams["." + extname] = passThrough;
    configureFn(stream._environment, passThrough, extname === targetExtname ? _targetEndStream : _dispatchEndStream);
  }
}