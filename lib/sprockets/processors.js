module.exports = {
  registerPreprocessor: function(mime_type, preprocessor){
    this.preprocessors[mime_type] = preprocessor;
  },
  registerPostprocessor: function(mime_type, postprocessor){
    this.postprocessors[mime_type] = postprocessor;
  }
};