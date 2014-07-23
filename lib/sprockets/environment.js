var path, Stream, Sprockets, VinylNodeCollection, RequireState, Base, Locals, SprocketsStream, Environment;
path = require('path');
Stream = require('stream');
Sprockets = require('../index');
VinylNodeCollection = require('../vinyl_node_collection');
RequireState = require('../vinyl_node_collection/require_state');
Base = require('./base');
Locals = require('./locals');
SprocketsStream = require('./stream');
Environment = (function(superclass){
  var Transform, PassThrough, prototype = extend$((import$(Environment, superclass).displayName = 'Environment', Environment), superclass).prototype, constructor = Environment;
  function Environment(){
    this._engines = Object.create(Sprockets._engines);
    this._engine_extensions = Object.create(Sprockets._engine_extensions);
    this._mime_exts = Object.create(Sprockets._mime_exts);
    this._mime_types = Object.create(Sprockets._mime_types);
    this._templates = Object.create(Sprockets._templates);
    this._preprocessors = Object.create(Sprockets._preprocessors);
    this._postprocessors = Object.create(Sprockets._postprocessors);
    this._view_locals = Object.create(Sprockets.viewLocals);
    this._manifest_filepaths = {};
    this._vinyl_node_collections = {};
    this._is_produciton = process.env.NODE_ENV === 'production';
    this._base_paths = [];
  }
  Object.defineProperty(prototype, 'isProduction', {
    get: function(){
      return this._is_produciton;
    },
    configurable: true,
    enumerable: true
  });
  Object.defineProperty(prototype, 'basePaths', {
    get: function(){
      return this._base_paths;
    },
    configurable: true,
    enumerable: true
  });
  Object.defineProperty(prototype, 'viewLocals', {
    get: function(){
      return Locals.call(Object.create(this._view_locals), this);
    },
    configurable: true,
    enumerable: true
  });
  prototype.createJavascriptsStream = function(){
    return this._create_stream('application/javascript');
  };
  prototype.createStylesheetsStream = function(){
    return this._create_stream('text/css');
  };
  prototype.createHtmlsStream = function(){
    return this._create_stream('text/html');
  };
  prototype.add_base_path = function(it){
    var _base_paths, i$, len$, basePath;
    _base_paths = this._base_paths;
    for (i$ = 0, len$ = _base_paths.length; i$ < len$; ++i$) {
      basePath = _base_paths[i$];
      if (basePath === it) {
        return false;
      }
    }
    return !!_base_paths.push(it);
  };
  Transform = Stream.Transform, PassThrough = Stream.PassThrough;
  prototype._create_stream = function(mimeType){
    var targetExtention, collection, ref$, tplEngines, extEngines, dispatchStartStream, dispatchEngineStream, dispatchEndStream, stream, this$ = this;
    targetExtention = this._mime_types[mimeType].extensions[0];
    collection = (ref$ = this._vinyl_node_collections)[mimeType] || (ref$[mimeType] = new VinylNodeCollection('application/javascript' !== mimeType));
    collection.updateVersion();
    function createTemplates(extname){
      var passThroughStream;
      passThroughStream = new PassThrough({
        objectMode: true
      });
      this$._templates[extname](this$, passThroughStream, dispatchEngineStream);
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
      this$._engines[extname](this$, passThroughStream, dispatchEngineStream);
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
      if (path.extname(path.basename(file.path, extname)) && this$._templates[extname]) {
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
    this._engines[targetExtention](this, extEngines[targetExtention], dispatchEndStream);
    return stream = new SprocketsStream({
      environment: this,
      mimeType: mimeType,
      collection: collection,
      dispatchStartStream: dispatchStartStream
    });
  };
  prototype.end_stream = function(stream){
    var mimeType, Postprocessor, collection;
    mimeType = stream.mimeType;
    Postprocessor = this._postprocessors[mimeType];
    collection = this._vinyl_node_collections[mimeType];
    new Postprocessor(this, collection, stream).process();
  };
  return Environment;
}(Base));
module.exports = Environment;
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