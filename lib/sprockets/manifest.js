var NoManifestDetected;
NoManifestDetected = require('../errors/no_manifest_detected');
module.exports = {
  getManifestFilepaths: function(mimeType, keyPath){
    var key, that;
    key = mimeType + keyPath;
    if (that = this._manifest_filepaths[key]) {
      return that;
    } else {
      throw NoManifestDetected(keyPath);
    }
  },
  setManifestFilepaths: function(mimeType, keyPath, filepaths){
    return this._manifest_filepaths[mimeType + keyPath] = filepaths;
  }
};