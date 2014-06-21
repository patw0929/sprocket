# `Engines` provides a global and `Environment` instance registry.
#
# An engine is a type of processor that is bound to a filename
# extension. `application.js.coffee` indicates that the
# `CoffeeScriptTemplate` engine will be ran on the file.
#
# Extensions can be stacked and will be evaulated from right to
# left. `application.js.coffee.erb` will first run `ERBTemplate`
# then `CoffeeScriptTemplate`.
#
# All `Engine`s must follow the `Template` interface. It is
# recommended to subclass `Template`.
#
# Its recommended that you register engine changes on your local
# `Environment` instance.
#
#     environment.register_engine '.foo', FooProcessor
#
# The global registry is exposed for plugins to register themselves.
#
#     Sprockets.register_engine '.sass', SassTemplate
#
module.exports = do
  # Returns a `Hash` of `Engine`s registered on the `Environment`.
  # If an `ext` argument is supplied, the `Engine` associated with
  # that extension will be returned.
  #
  #     environment.engines
  #     # => {".coffee" => CoffeeScriptTemplate, ".sass" => SassTemplate, ...}
  #
  # attr_reader :engines

  # Internal: Returns a `Hash` of engine extensions to format extensions.
  #
  # # => { '.coffee' => '.js' }
  # attr_reader :engine_extensions

  # Internal: Find and load engines by extension.
  #
  # extnames - Array of String extnames
  #
  # Returns Array of Procs.
  # def unwrap_engines(extnames)
  #   extnames.map { |ext|
  #     engines[ext]
  #   }.map { |engine|
  #     unwrap_processor(engine)
  #   }
  # end

  # Registers a new Engine `klass` for `ext`. If the `ext` already
  # has an engine registered, it will be overridden.
  #
  #     environment.register_engine '.coffee', CoffeeScriptTemplate
  #
  registerEngine: !(ext, engineFn, options) ->
    # ext = Sprockets::Utils.normalize_extension(ext)
    @engines[ext] = engineFn
    if options.mime_type
      @engine_extensions[ext] = @mime_types[that].extensions.first

  # private
  #   def deep_copy_hash(hash)
  #     initial = Hash.new { |h, k| h[k] = [] }
  #     hash.each_with_object(initial) { |(k, a),h| h[k] = a.dup }
  #   end
