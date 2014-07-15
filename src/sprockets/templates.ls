module.exports = do

  # Registers a new Template `klass` for `ext`. If the `ext` already
  # has an engine registered, it will be overridden.
  #
  #     environment.register_template '.eco', EcoTemplate
  #
  registerTemplate: !(ext, templateFn) ->
    # ext = Sprockets::Utils.normalize_extension(ext)
    @_templates[ext] = templateFn
