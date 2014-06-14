var path, nconf, SprocketRequireState, SUPPORTED_ANCESTORS, prototype;
path = require('path');
nconf = require('nconf');
SprocketRequireState = require('./vinyl_node/require_state');
SUPPORTED_ANCESTORS = {
  javascripts: 'js',
  stylesheets: 'css'
};
SprocketEnvironment.SUPPORTED_ANCESTORS = SUPPORTED_ANCESTORS;
module.exports = SprocketEnvironment;
/*
 * SprocketEnvironment
 */
function SprocketEnvironment(options){
  var key, ref$, val;
  for (key in ref$ = options || {}) {
    val = ref$[key];
    this[key] = val;
  }
  this._basePaths = [];
}
/*
 * SprocketEnvironment.prototype
 */
prototype = SprocketEnvironment.prototype;
Object.defineProperty(prototype, 'isProduction', {
  get: function(){
    return 'production' === nconf.get('NODE_ENV');
  },
  configurable: true,
  enumerable: true
});
Object.defineProperty(prototype, 'basePaths', {
  get: function(){
    return this._basePaths;
  },
  configurable: true,
  enumerable: true
});
prototype.addBasePath = function(it){
  var _basePaths, i$, len$, basePath;
  _basePaths = this._basePaths;
  for (i$ = 0, len$ = _basePaths.length; i$ < len$; ++i$) {
    basePath = _basePaths[i$];
    if (basePath === it) {
      return false;
    }
  }
  return !!_basePaths.push(it);
};