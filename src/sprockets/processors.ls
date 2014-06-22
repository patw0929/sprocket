module.exports = do

  registerPostprocessor: !(mime_type, postprocessor) ->
    @postprocessors[mime_type] = postprocessor
