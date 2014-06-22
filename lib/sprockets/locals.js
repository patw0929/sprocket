var os, url, ref$;
os = require('os');
url = require('url');
module.exports = Locals;
function Locals(_environment){
  var name, ref$, fn;
  this._environment = _environment;
  for (name in ref$ = Locals.prototype) {
    fn = ref$[name];
    this[underscore(name)] = this[name] = fn.bind(this);
  }
  return this;
}
ref$ = Locals.prototype;
ref$.javascriptIncludeTag = function(keyPath, options){
  options || (options = {});
  options.assetsPath || (options.assetsPath = '/assets/');
  options.indent || (options.indent = '    ');
  return this._environment.getManifestFilepaths('application/javascript', keyPath).map(createScriptTag, options).join(os.EOL);
};
ref$.stylesheetLinkTag = function(keyPath, options){
  options || (options = {});
  options.assetsPath || (options.assetsPath = '/assets/');
  options.indent || (options.indent = '    ');
  return this._environment.getManifestFilepaths('text/css', keyPath).map(createStyleTag, options).join(os.EOL);
};
/*
 * Private APIs
 */
function underscore(it){
  return it.replace(/([A-Z])/g, underscoreReplacer);
}
function underscoreReplacer(it){
  return "_" + it.toLowerCase();
}
function createScriptTag(it, index){
  return "" + (0 === index ? os.EOL : '') + this.indent + "<script type=\"text/javascript\" src=\"" + url.resolve(this.assetsPath, it) + "\"></script>";
}
function createStyleTag(it, index){
  return "" + (0 === index ? os.EOL : '') + this.indent + "<link rel=\"stylesheet\" href=\"" + url.resolve(this.assetsPath, it) + "\">";
}