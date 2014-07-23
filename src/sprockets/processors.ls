module.exports = do

  registerPreprocessor: !(mimeType, preprocessor) ->
    @_preprocessors[mimeType] = preprocessor

  registerPostprocessor: !(mimeType, postprocessor) ->
    @_postprocessors[mimeType] = postprocessor
