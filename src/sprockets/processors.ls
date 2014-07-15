module.exports = do

  registerPreprocessor: !(mime_type, preprocessor) ->
    @_preprocessors[mime_type] = preprocessor

  registerPostprocessor: !(mime_type, postprocessor) ->
    @postprocessors[mime_type] = postprocessor
