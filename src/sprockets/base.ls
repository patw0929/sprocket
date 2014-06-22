require! {
  crypto
}
require! {
  Bundle: './bundle'
  Manifest: './manifest'
  Mime: './mime'
  Engines: './engines'
}
# `Base` class for `Environment` and `Cached`.
module.exports = class implements Bundle, Manifest, Mime, Engines
  # Returns a `Digest` implementation class.
  #
  # Defaults to `Digest::SHA1`.
  # attr_reader :digest_class

  # Assign a `Digest` implementation class. This maybe any Ruby
  # `Digest::` implementation such as `Digest::SHA1` or
  # `Digest::MD5`.
  #
  #     environment.digest_class = Digest::MD5
  #
  digestHash:~
    -> crypto.createHash @_digestHashName || 'sha1'
    (it) ->
      # expire_cache!
      @_digestHashName = it

  # The `Environment#version` is a custom value used for manually
  # expiring all asset caches.
  #
  # Sprockets is able to track most file and directory changes and
  # will take care of expiring the cache for you. However, its
  # impossible to know when any custom helpers change that you mix
  # into the `Context`.
  #
  # It would be wise to increment this value anytime you make a
  # configuration change to the `Environment` object.
  # attr_reader :version

  # Assign an environment version.
  #
  #     environment.version = '2.0'
  #
  version:~
    -> @_version
    (it) ->
      # expire_cache!
      @_version = it
  