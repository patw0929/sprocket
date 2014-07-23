var crypto, Manifest, Mime, Engines, Templates, Processors;
crypto = require('crypto');
Manifest = require('./manifest');
Mime = require('./mime');
Engines = require('./engines');
Templates = require('./templates');
Processors = require('./processors');
module.exports = (function(){
  exports.displayName = 'exports';
  var prototype = exports.prototype, constructor = exports;
  importAll$(prototype, arguments[0]);
  importAll$(prototype, arguments[1]);
  importAll$(prototype, arguments[2]);
  importAll$(prototype, arguments[3]);
  importAll$(prototype, arguments[4]);
  Object.defineProperty(prototype, 'digestHash', {
    get: function(){
      return crypto.createHash(this._digest_hash_name || 'sha1');
    },
    set: function(it){
      this._digest_hash_name = it;
    },
    configurable: true,
    enumerable: true
  });
  prototype.hexDigestFor = function(contents){
    return this.digestHash.update(contents).digest('hex').slice(0, 32);
  };
  Object.defineProperty(prototype, 'version', {
    get: function(){
      return this._version;
    },
    set: function(it){
      this._version = it;
    },
    configurable: true,
    enumerable: true
  });
  function exports(){}
  return exports;
}(Manifest, Mime, Engines, Templates, Processors));
function importAll$(obj, src){
  for (var key in src) obj[key] = src[key];
  return obj;
}