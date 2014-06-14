var os, util, path, crypto, File, RequireState, k, v, EOL_BUF, MINIFIED_EXTNAME, ref$, MANIFEST_BASENAME, MANIFEST_EXTNAME;
os = require('os');
util = require('util');
path = require('path');
crypto = require('crypto');
File = require('vinyl');
RequireState = require('../../vinyl_node/require_state');
module.exports = SprocketRequireState;
SprocketRequireState.getManifestFilepath = getManifestFilepath;
/*                           ({keyPath, isProduction, extname}) */
function getManifestFilepath(baseAndExtnames){
  if (!Array.isArray(baseAndExtnames)) {
    baseAndExtnames = keyPath2BaseAndExtnames.apply(null, arguments);
  }
  baseAndExtnames.splice(1, 0, MANIFEST_BASENAME);
  baseAndExtnames.push(MANIFEST_EXTNAME);
  return baseAndExtnames.join('');
}
/*
 * SprocketRequireState
 */
util.inherits(SprocketRequireState, RequireState);
for (k in RequireState) {
  v = RequireState[k];
  SprocketRequireState[k] = v;
}
function SprocketRequireState(){
  RequireState.apply(this, arguments);
  this._md5 = crypto.createHash('md5');
}
/*
 * SprocketRequireState.prototype
 */
EOL_BUF = new Buffer(os.EOL);
MINIFIED_EXTNAME = '.min';
ref$ = SprocketRequireState.prototype;
ref$.concatFile = function(manifestFiles, vinyls, options){
  var baseAndExtnames, basename, _nodes, contents, targetStart, i$, len$, node, that, j$, ref$, len1$, sourceBuffer, fingerprint, filepath;
  baseAndExtnames = keyPath2BaseAndExtnames(options);
  basename = baseAndExtnames[0];
  _nodes = this._nodes;
  contents = new Buffer(this._totalBufferSize + _nodes.length * EOL_BUF.length);
  targetStart = 0;
  for (i$ = 0, len$ = _nodes.length; i$ < len$; ++i$) {
    node = _nodes[i$];
    if (that = node.vinyl.contents) {
      for (j$ = 0, len1$ = (ref$ = [that, EOL_BUF]).length; j$ < len1$; ++j$) {
        sourceBuffer = ref$[j$];
        sourceBuffer.copy(contents, targetStart);
        targetStart += sourceBuffer.length;
      }
    }
  }
  fingerprint = this._md5.update(contents).digest('hex').slice(0, 32);
  filepath = basename + "-" + fingerprint + baseAndExtnames[1];
  vinyls[basename] = new File({
    path: filepath,
    contents: contents
  });
  createManifestVinyl(manifestFiles, vinyls, baseAndExtnames, [filepath]);
};
ref$.buildManifestFile = function(manifestFiles, vinyls, options){
  createManifestVinyl(manifestFiles, vinyls, options, this._nodes.map(function(vn){
    var vinyl, filepath, extname, basename;
    vinyl = vn.vinyl;
    filepath = vinyl.path;
    extname = path.extname(filepath);
    basename = path.basename(filepath, extname);
    if (options.isProduction) {
      extname = MINIFIED_EXTNAME + "" + extname;
    }
    vinyl.path = path.join(path.dirname(filepath), basename + "" + extname);
    vinyls[vn.keyPath] = vinyl;
    return vinyl.relative;
  }));
};
MANIFEST_BASENAME = '-manifest';
MANIFEST_EXTNAME = '.json';
function keyPath2BaseAndExtnames(arg$){
  var keyPath, isProduction, extname, extnames;
  keyPath = arg$.keyPath, isProduction = arg$.isProduction, extname = arg$.extname;
  extnames = [extname];
  if (isProduction) {
    extnames.unshift(MINIFIED_EXTNAME);
  }
  return [path.join(path.dirname(keyPath), path.basename(keyPath)), extnames.join('')];
}
function createManifestVinyl(manifestFiles, vinyls, options, pathsArray){
  var manifestFilepath;
  manifestFilepath = getManifestFilepath(options);
  vinyls[manifestFilepath] = new File({
    path: manifestFilepath,
    contents: new Buffer(JSON.stringify(pathsArray, null, 2))
  });
  manifestFiles[manifestFilepath] = pathsArray;
}