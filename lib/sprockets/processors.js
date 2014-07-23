module.exports = {
  registerPreprocessor: function(mimeType, preprocessor){
    this._preprocessors[mimeType] = preprocessor;
  },
  registerPostprocessor: function(mimeType, postprocessor){
    this._postprocessors[mimeType] = postprocessor;
  }
};