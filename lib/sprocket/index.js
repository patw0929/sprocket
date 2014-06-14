var os, url, SprocketStream, SprocketCollection, SprocketEnvironment, prototype, SUPPORTED_ANCESTORS, slice$ = [].slice;
os = require('os');
url = require('url');
SprocketStream = require('./stream');
SprocketCollection = require('./vinyl_node');
SprocketEnvironment = require('./environment');
module.exports = Sprocket;
Sprocket.Stream = SprocketStream;
/*
 * Sprocket
 */
function Sprocket(options){
  this.options = options || {};
  this._javascriptsExtensions = {};
  this._stylesheetsExtensions = {};
  this._nodeCollections = {};
  this.environment = new SprocketEnvironment(this.options.environment);
}
/*
 * Sprocket.prototype
 */
prototype = Sprocket.prototype;
SUPPORTED_ANCESTORS = SprocketEnvironment.SUPPORTED_ANCESTORS;
Object.keys(SUPPORTED_ANCESTORS).forEach(function(ancestor){
  prototype["create" + titleize(ancestor) + "Stream"] = function(){
    return this.createStream.apply(this, [ancestor].concat(slice$.call(arguments)));
  };
});
prototype.registerHandler = function(ancestor, extnames, handler){
  var ref$;
  if (!(ancestor in SUPPORTED_ANCESTORS)) {
    throw "Currently we only support " + SUPPORTED_ANCESTORS.join(',');
  }
  (ref$ = this._nodeCollections)[ancestor] || (ref$[ancestor] = new SprocketCollection());
  extnames.forEach(function(extension){
    this[extension] = handler;
  }, this["_" + ancestor + "Extensions"]);
  return this;
};
prototype.createStream = function(ancestor){
  if (!(ancestor in SUPPORTED_ANCESTORS)) {
    throw "Currently we only support " + SUPPORTED_ANCESTORS.join(',');
  }
  return new SprocketStream({
    environment: this.environment,
    collection: this._nodeCollections[ancestor],
    extname: SUPPORTED_ANCESTORS[ancestor],
    extensions: this["_" + ancestor + "Extensions"]
  });
};
prototype.createViewHelpers = function(options){
  var this$ = this;
  options || (options = {});
  options.assetsPath || (options.assetsPath = '/');
  options.indent || (options.indent = '    ');
  return Object.keys(SUPPORTED_ANCESTORS).reduce(function(helpers, ancestor){
    var helperName;
    function helperFn(it){
      return getManifestAsJson(this$, ancestor, it).map(getManifestAsJson[ancestor + "MapFn"], options).join(os.EOL);
    }
    helperName = getManifestAsJson[ancestor];
    helpers[helperName] = helperFn;
    if (helperName.match(/Tag$/)) {
      helpers[underscore(helperName)] = helperFn;
    }
    return helpers;
  }, {});
};
function getManifestAsJson(sprocket, ancestor, keyPath){
  return sprocket._nodeCollections[ancestor].getManifestContent({
    keyPath: keyPath,
    isProduction: sprocket.environment.isProduction,
    extname: "." + SUPPORTED_ANCESTORS[ancestor]
  });
}
getManifestAsJson.javascripts = 'javascriptIncludeTag';
getManifestAsJson.javascriptsMapFn = function(it, index){
  return "" + (0 === index ? os.EOL : '') + this.indent + "<script type=\"text/javascript\" src=\"" + url.resolve(this.assetsPath, it) + "\"></script>";
};
getManifestAsJson.stylesheets = 'stylesheetLinkTag';
getManifestAsJson.stylesheetsMapFn = function(it, index){
  return "" + (0 === index ? os.EOL : '') + this.indent + "<link rel=\"stylesheet\" href=\"" + url.resolve(this.assetsPath, it) + "\">";
};
function underscore(it){
  return it.replace(/([A-Z])/g, underscoreReplacer);
}
function underscoreReplacer(it){
  return "_" + it.toLowerCase();
}
function titleize(it){
  return it.charAt(0).toUpperCase() + "" + it.slice(1);
}