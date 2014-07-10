var os, path, File, EOL_BUF, MANIFEST_BASENAME, MANIFEST_EXTNAME, BundleOrManifest;
os = require('os');
path = require('path');
File = require('vinyl');
EOL_BUF = new Buffer(os.EOL);
MANIFEST_BASENAME = '-manifest';
MANIFEST_EXTNAME = '.json';
BundleOrManifest = (function(){
  BundleOrManifest.displayName = 'BundleOrManifest';
  var prototype = BundleOrManifest.prototype, constructor = BundleOrManifest;
  function BundleOrManifest(environment, collection, stream){
    this.environment = environment;
    this.collection = collection;
    this.stream = stream;
    this.mimeType = stream.mimeType;
    this.outputtedPaths = {};
  }
  prototype.process = function(){
    var fn;
    fn = this.environment.isProduction
      ? this.bundle
      : this.manifest;
    this.collection.createRequireStates().forEach(fn, this);
  };
  prototype.bundle = function(requireState){
    var keyPath, vinyls, dirname, basename, extname, contents, targetStart, i$, len$, vinyl, j$, ref$, len1$, sourceBuffer, fingerprint, filepath, relativeFilepaths;
    keyPath = requireState.keyPath, vinyls = requireState.vinyls;
    dirname = path.dirname(keyPath);
    basename = path.basename(keyPath);
    extname = ".min" + this.environment.extnameForMimeType(this.mimeType);
    contents = requireState.bufferWithSeperator(EOL_BUF);
    targetStart = 0;
    for (i$ = 0, len$ = vinyls.length; i$ < len$; ++i$) {
      vinyl = vinyls[i$];
      for (j$ = 0, len1$ = (ref$ = [vinyl.contents, EOL_BUF]).length; j$ < len1$; ++j$) {
        sourceBuffer = ref$[j$];
        sourceBuffer.copy(contents, targetStart);
        targetStart += sourceBuffer.length;
      }
    }
    fingerprint = this.environment.hexDigestFor(contents);
    filepath = path.join(dirname, basename + "-" + fingerprint + extname);
    this.stream.push(new File({
      path: filepath,
      contents: contents
    }));
    relativeFilepaths = [filepath];
    this.environment.setManifestFilepaths(this.mimeType, keyPath, relativeFilepaths);
    this.stream.push(new File({
      path: path.join(dirname, basename + "" + MANIFEST_BASENAME + extname + MANIFEST_EXTNAME),
      contents: new Buffer(JSON.stringify(relativeFilepaths))
    }));
  };
  prototype.manifest = function(requireState){
    var pathsChanged, nothingChanged, vinyls, keyPath, relativeFilepaths, dirname, basename, extname;
    pathsChanged = requireState.pathsChanged, nothingChanged = requireState.nothingChanged, vinyls = requireState.vinyls, keyPath = requireState.keyPath;
    if (nothingChanged) {
      return;
    }
    relativeFilepaths = vinyls.map(function(vinyl){
      var path;
      path = vinyl.path;
      if (pathsChanged[path] && !this.outputtedPaths[path]) {
        this.outputtedPaths[path] = true;
        this.stream.push(vinyl);
      }
      return vinyl.relative;
    }, this);
    this.environment.setManifestFilepaths(this.mimeType, keyPath, relativeFilepaths);
    dirname = path.dirname(keyPath);
    basename = path.basename(keyPath);
    extname = this.environment.extnameForMimeType(this.mimeType);
    this.stream.push(new File({
      path: path.join(dirname, basename + "" + MANIFEST_BASENAME + extname + MANIFEST_EXTNAME),
      contents: new Buffer(JSON.stringify(relativeFilepaths, null, 2))
    }));
  };
  return BundleOrManifest;
}());
module.exports = BundleOrManifest;