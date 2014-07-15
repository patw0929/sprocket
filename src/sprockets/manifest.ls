require! {
  NoManifestDetected: '../errors/no_manifest_detected'
}

module.exports = do
  getManifestFilepaths: (mimeType, keyPath) ->
    const key = mimeType + keyPath
    if @_manifest_filepaths[key]
      that
    else
      throw NoManifestDetected keyPath

  setManifestFilepaths: (mimeType, keyPath, filepaths) ->
    @_manifest_filepaths[mimeType + keyPath] = filepaths
