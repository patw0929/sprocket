var path, Stream, Sprockets, VinylNodeCollection, RequireState, Base, Locals, SprocketsStream, Environment, Transform, PassThrough, ref$;
path = require('path');
Stream = require('stream');
Sprockets = require('../index');
VinylNodeCollection = require('../vinyl_node_collection');
RequireState = require('../vinyl_node_collection/require_state');
Base = require('./base');
Locals = require('./locals');
SprocketsStream = require('./stream');
Environment = (function(superclass){
  var prototype = extend$((import$(Environment, superclass).displayName = 'Environment', Environment), superclass).prototype, constructor = Environment;
  function Environment(){
    this.engines = Object.create(Sprockets.engines);
    this.engine_extensions = Object.create(Sprockets.engine_extensions);
    this.mime_exts = Object.create(Sprockets.mime_exts);
    this.mime_types = Object.create(Sprockets.mime_types);
    this.templates = Object.create(Sprockets.templates);
    this.preprocessors = Object.create(Sprockets.preprocessors);
    this.postprocessors = Object.create(Sprockets.postprocessors);
    this.view_locals = Object.create(Sprockets.viewLocals);
    this.manifest_filepaths = {};
    this.vinyl_node_collections = {};
    this.is_produciton = process.env.NODE_ENV === 'production';
    this.base_paths = [];
  }
  Object.defineProperty(prototype, 'isProduction', {
    get: function(){
      return this.is_produciton;
    },
    configurable: true,
    enumerable: true
  });
  Object.defineProperty(prototype, 'basePaths', {
    get: function(){
      return this.base_paths;
    },
    configurable: true,
    enumerable: true
  });
  Object.defineProperty(prototype, 'viewLocals', {
    get: function(){
      return Locals.call(Object.create(this.view_locals), this);
    },
    configurable: true,
    enumerable: true
  });
  prototype.createJavascriptsStream = function(){
    return this._createStream('application/javascript');
  };
  prototype.createStylesheetsStream = function(){
    return this._createStream('text/css');
  };
  prototype.createHtmlsStream = function(){
    return this._createStream('text/html');
  };
  return Environment;
}(Base));
module.exports = Environment;
Transform = Stream.Transform, PassThrough = Stream.PassThrough;
ref$ = Environment.prototype;
ref$._addBasePath = function(it){
  var base_paths, i$, len$, basePath;
  base_paths = this.base_paths;
  for (i$ = 0, len$ = base_paths.length; i$ < len$; ++i$) {
    basePath = base_paths[i$];
    if (basePath === it) {
      return false;
    }
  }
  return !!base_paths.push(it);
};
ref$._createStream = function(mime_type){
  var targetExtention, collection, ref$, tplEngines, extEngines, dispatchStartStream, dispatchEngineStream, dispatchEndStream, stream, this$ = this;
  targetExtention = this.mime_types[mime_type].extensions[0];
  collection = (ref$ = this.vinyl_node_collections)[mime_type] || (ref$[mime_type] = new VinylNodeCollection('text/html' === mime_type));
  collection.updateVersion();
  function createTemplates(extname){
    var passThroughStream;
    passThroughStream = new PassThrough({
      objectMode: true
    });
    this$.templates[extname](this$, passThroughStream, dispatchEngineStream);
    return passThroughStream;
  }
  function getOrCreateTemplates(extname){
    return tplEngines[extname] || (tplEngines[extname] = createTemplates(extname));
  }
  function createEngines(extname){
    var passThroughStream;
    passThroughStream = new PassThrough({
      objectMode: true
    });
    this$.engines[extname](this$, passThroughStream, dispatchEngineStream);
    return passThroughStream;
  }
  function getOrCreateEngines(extname){
    return extEngines[extname] || (extEngines[extname] = createEngines(extname));
  }
  tplEngines = {};
  extEngines = {};
  dispatchStartStream = new Transform({
    objectMode: true
  });
  dispatchStartStream._transform = function(file, enc, done){
    var extname;
    extname = path.extname(file.path);
    if (path.extname(path.basename(file.path, extname)) && this$.templates[extname]) {
      getOrCreateTemplates(extname).write(file);
    } else {
      getOrCreateEngines(extname).write(file);
    }
    done();
  };
  dispatchEngineStream = new Transform({
    objectMode: true
  });
  dispatchEngineStream._transform = function(file, enc, done){
    getOrCreateEngines(path.extname(file.path)).write(file);
    done();
  };
  dispatchEndStream = new Transform({
    objectMode: true
  });
  dispatchEndStream._transform = function(file, enc, done){
    collection.finalizeNode(file, stream);
    stream._endEventually();
    done();
  };
  extEngines[targetExtention] = new PassThrough({
    objectMode: true
  });
  this.engines[targetExtention](this, extEngines[targetExtention], dispatchEndStream);
  return stream = new SprocketsStream({
    mimeType: mime_type,
    environment: this,
    collection: collection,
    dispatchStartStream: dispatchStartStream
  });
};
ref$._endStream = function(stream){
  var mimeType, Postprocessor, collection;
  mimeType = stream.mimeType;
  Postprocessor = this.postprocessors[mimeType];
  collection = this.vinyl_node_collections[mimeType];
  new Postprocessor(this, collection, stream).process();
};
function extend$(sub, sup){
  function fun(){} fun.prototype = (sub.superclass = sup).prototype;
  (sub.prototype = new fun).constructor = sub;
  if (typeof sup.extended == 'function') sup.extended(sub);
  return sub;
}
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}