var Engines, Mime, Templates, Processors, Environment, EjsEngine, JsEngine, LsEngine, CssEngine, ScssEngine, LessEngine, HtmlEngine, JadeEngine, EjsTemplate, BundleOrManifestPostprocessor, PassThroughPostprocessor;
Engines = require('./sprockets/engines');
Mime = require('./sprockets/mime');
Templates = require('./sprockets/templates');
Processors = require('./sprockets/processors');
Environment = require('./sprockets/environment');
EjsEngine = require('./engines/ejs');
JsEngine = require('./engines/js');
LsEngine = require('./engines/ls');
CssEngine = require('./engines/css');
ScssEngine = require('./engines/scss');
LessEngine = require('./engines/less');
HtmlEngine = require('./engines/html');
JadeEngine = require('./engines/jade');
EjsTemplate = require('./templates/ejs');
BundleOrManifestPostprocessor = require('./processors/bundle_or_manifest');
PassThroughPostprocessor = require('./processors/pass_through');
exports.Environment = Environment;
import$(exports, Engines);
import$(exports, Mime);
import$(exports, Templates);
import$(exports, Processors);
exports._engines = {};
exports._engine_extensions = {};
exports._mime_exts = {};
exports._mime_types = {};
exports._templates = {};
exports._preprocessors = {};
exports._postprocessors = {};
exports.viewLocals = {};
exports.registerMimeType('application/javascript', {
  extensions: ['.js']
});
exports.registerMimeType('text/css', {
  extensions: ['.css']
});
exports.registerMimeType('text/html', {
  extensions: ['.html', '.htm']
});
exports.registerMimeType('text/plain', {
  extensions: ['.txt', '.text']
});
exports.registerTemplate('.ejs', EjsTemplate);
exports.registerPostprocessor('application/javascript', BundleOrManifestPostprocessor);
exports.registerPostprocessor('text/css', BundleOrManifestPostprocessor);
exports.registerPostprocessor('text/html', PassThroughPostprocessor);
exports.registerEngine('.js', JsEngine, {
  mimeType: 'application/javascript'
});
exports.registerEngine('.ls', LsEngine, {
  mimeType: 'application/javascript'
});
exports.registerEngine('.css', CssEngine, {
  mimeType: 'text/css'
});
exports.registerEngine('.scss', ScssEngine, {
  mimeType: 'text/css'
});
exports.registerEngine('.sass', ScssEngine, {
  mimeType: 'text/css'
});
exports.registerEngine('.less', LessEngine, {
  mimeType: 'text/css'
});
exports.registerEngine('.html', HtmlEngine, {
  mimeType: 'text/html'
});
exports.registerEngine('.jade', JadeEngine, {
  mimeType: 'text/html'
});
exports.registerEngine('.ejs', EjsEngine, {
  mimeType: 'text/html'
});
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}