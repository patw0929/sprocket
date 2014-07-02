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
exports.engines = {};
exports.engine_extensions = {};
exports.mime_exts = {};
exports.mime_types = {};
exports.templates = {};
exports.preprocessors = {};
exports.postprocessors = {};
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
  mime_type: 'application/javascript'
});
exports.registerEngine('.ls', LsEngine, {
  mime_type: 'application/javascript'
});
exports.registerEngine('.css', CssEngine, {
  mime_type: 'text/css'
});
exports.registerEngine('.scss', ScssEngine, {
  mime_type: 'text/css'
});
exports.registerEngine('.sass', ScssEngine, {
  mime_type: 'text/css'
});
exports.registerEngine('.less', LessEngine, {
  mime_type: 'text/css'
});
exports.registerEngine('.html', HtmlEngine, {
  mime_type: 'text/html'
});
exports.registerEngine('.jade', JadeEngine, {
  mime_type: 'text/html'
});
exports.registerEngine('.ejs', EjsEngine, {
  mime_type: 'text/html'
});
function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}