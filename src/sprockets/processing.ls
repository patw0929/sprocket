# `Processing` is an internal mixin whose public methods are exposed on
# the `Environment` and `CachedEnvironment` classes.
module.exports = do
  # Preprocessors are ran before Postprocessors and Engine
  # processors.
  # attr_reader :preprocessors

  # Postprocessors are ran after Preprocessors and Engine processors.
  # attr_reader :postprocessors

  # Registers a new Preprocessor `klass` for `mime_type`.
  #
  #     register_preprocessor 'text/css', Sprockets::DirectiveProcessor
  #
  # A block can be passed for to create a shorthand processor.
  #
  #     register_preprocessor 'text/css', :my_processor do |context, data|
  #       data.gsub(...)
  #     end
  #
  registerPreprocessor: !(mime_type, engine) ->
    @preprocessors[][mime_type].push engine

  # Registers a new Postprocessor `klass` for `mime_type`.
  #
  #     register_postprocessor 'application/javascript', Sprockets::DirectiveProcessor
  #
  # A block can be passed for to create a shorthand processor.
  #
  #     register_postprocessor 'application/javascript', :my_processor do |context, data|
  #       data.gsub(...)
  #     end
  #
  registerPostprocessor: !(mime_type, engine) ->
    @postprocessors[][mime_type].push engine

  # Bundle Processors are ran on concatenated assets rather than
  # individual files.
  # attr_reader :bundle_processors

  # Registers a new Bundle Processor `klass` for `mime_type`.
  #
  #     register_bundle_processor  'application/javascript', Sprockets::DirectiveProcessor
  #
  # A block can be passed for to create a shorthand processor.
  #
  #     register_bundle_processor 'application/javascript', :my_processor do |context, data|
  #       data.gsub(...)
  #     end
  #
  registerBundleProcessor: !(mime_type, engine) ->
    @bundle_processors[][mime_type].push engine
  