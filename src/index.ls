require! {
  Engines: './sprockets/engines'
  Mime: './sprockets/mime'
  Templates: './sprockets/templates'
  Processors: './sprockets/processors'
  Environment: './sprockets/environment'
}
# `Compressing` module: not needed since it's built-in
require! {
  EjsEngine: './engines/ejs'
  JsEngine: './engines/js'
  LsEngine: './engines/ls'
  CssEngine: './engines/css'
  ScssEngine: './engines/scss'
  LessEngine: './engines/less'
  HtmlEngine: './engines/html'
  JadeEngine: './engines/jade'
}
require! {
  EjsTemplate: './templates/ejs'
}
require! {
  BundleOrManifestPostprocessor: './processors/bundle_or_manifest'
  PassThroughPostprocessor: './processors/pass_through'
}
exports <<< {Environment}
# --- sprocket.rb ---
# # Extend Sprockets module to provide global registry
# extend Engines, Mime, Processing, Compressing, Paths
# --- sprocket.rb ---
exports <<< Engines
exports <<< Mime
exports <<< Templates
exports <<< Processors
# --- sprocket.rb ---
# @root              = File.expand_path('..', __FILE__)
# @paths             = []
# @mime_types        = {}
# @mime_exts         = {}
# @engines           = {}
# @engine_extensions = {}
# @preprocessors     = Hash.new { |h, k| h[k] = [] }
# @postprocessors    = Hash.new { |h, k| h[k] = [] }
# @bundle_processors = Hash.new { |h, k| h[k] = [] }
# @compressors       = Hash.new { |h, k| h[k] = {} }
# --- sprocket.rb ---
exports._engines            = {}
exports._engine_extensions  = {}
exports._mime_exts          = {}
exports._mime_types         = {}
exports._templates          = {}
exports._preprocessors      = {}
exports._postprocessors     = {}
#
# Public API
#
exports.viewLocals        = {}
# --- sprocket.rb ---
# # Common asset text types
# register_mime_type 'application/javascript', extensions: ['.js'], charset: EncodingUtils::DETECT_UNICODE
# register_mime_type 'application/json', extensions: ['.json'], charset: EncodingUtils::DETECT_UNICODE
# register_mime_type 'text/css', extensions: ['.css'], charset: EncodingUtils::DETECT_CSS
# register_mime_type 'text/html', extensions: ['.html', '.htm'], charset: EncodingUtils::DETECT_HTML
# register_mime_type 'text/plain', extensions: ['.txt', '.text']
# register_mime_type 'text/yaml', extensions: ['.yml', '.yaml'], charset: EncodingUtils::DETECT_UNICODE
# --- sprocket.rb ---
exports.registerMimeType 'application/javascript', extensions: <[ .js ]>
# exports.registerMimeType 'application/json', extensions: <[ .js ]>
exports.registerMimeType 'text/css', extensions: <[ .css ]>
exports.registerMimeType 'text/html', extensions: <[ .html .htm ]>
exports.registerMimeType 'text/plain', extensions: <[ .txt .text ]>
# exports.registerMimeType 'text/yaml', extensions: <[ .yml .yaml ]>
# --- sprocket.rb ---
# ...images, fonts, audio, video
# --- sprocket.rb ---
# --- sprocket.rb ---
# register_preprocessor 'text/css', DirectiveProcessor
# register_preprocessor 'application/javascript', DirectiveProcessor
# --- sprocket.rb ---
exports.registerTemplate '.ejs', EjsTemplate
# --- sprocket.rb ---
# register_bundle_processor 'application/javascript', Bundle
# register_bundle_processor 'text/css', Bundle
# --- sprocket.rb ---
exports.registerPostprocessor 'application/javascript', BundleOrManifestPostprocessor
exports.registerPostprocessor 'text/css', BundleOrManifestPostprocessor
exports.registerPostprocessor 'text/html', PassThroughPostprocessor
# --- sprocket.rb ---
# register_compressor 'text/css', :sass, LazyProcessor.new { SassCompressor }
# register_compressor 'text/css', :scss, LazyProcessor.new { SassCompressor }
# register_compressor 'text/css', :yui, LazyProcessor.new { YUICompressor }
# register_compressor 'application/javascript', :closure, LazyProcessor.new { ClosureCompressor }
# register_compressor 'application/javascript', :uglifier, LazyProcessor.new { UglifierCompressor }
# register_compressor 'application/javascript', :uglify, LazyProcessor.new { UglifierCompressor }
# register_compressor 'application/javascript', :yui, LazyProcessor.new { YUICompressor }
# --- sprocket.rb ---
# --- sprocket.rb ---
# # Mmm, CoffeeScript
# register_engine '.coffee', LazyProcessor.new { CoffeeScriptTemplate }, mime_type: 'application/javascript'
# --- sprocket.rb ---
exports.registerEngine '.js', JsEngine, mimeType: 'application/javascript'
exports.registerEngine '.ls', LsEngine, mimeType: 'application/javascript'
# --- sprocket.rb ---
# # JST engines
# register_engine '.jst',    LazyProcessor.new { JstProcessor }, mime_type: 'application/javascript'
# register_engine '.eco',    LazyProcessor.new { EcoTemplate },  mime_type: 'application/javascript'
# register_engine '.ejs',    LazyProcessor.new { EjsTemplate },  mime_type: 'application/javascript'
# --- sprocket.rb ---
# --- sprocket.rb ---
# # CSS engines
# register_engine '.sass',   LazyProcessor.new { SassTemplate }, mime_type: 'text/css'
# register_engine '.scss',   LazyProcessor.new { ScssTemplate }, mime_type: 'text/css'
# --- sprocket.rb ---
exports.registerEngine '.css', CssEngine, mimeType: 'text/css'
exports.registerEngine '.scss', ScssEngine, mimeType: 'text/css'
exports.registerEngine '.sass', ScssEngine, mimeType: 'text/css'
exports.registerEngine '.less', LessEngine, mimeType: 'text/css'
# --- sprocket.rb ---
# # Other
# register_engine '.erb',    LazyProcessor.new { ERBTemplate }
# --- sprocket.rb ---
exports.registerEngine '.html', HtmlEngine, mimeType: 'text/html'
exports.registerEngine '.jade', JadeEngine, mimeType: 'text/html'
exports.registerEngine '.ejs', EjsEngine, mimeType: 'text/html'
