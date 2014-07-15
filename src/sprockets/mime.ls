# https://github.com/sstephenson/sprockets/commit/519a49e445261adfca1e651120e50f58ec7bb8a4#diff-ba679810faf4553186c83bc4afb68087
module.exports = do
  # Pubic: Mapping of MIME type Strings to properties Hash.
  #
  # key   - MIME Type String
  # value - Hash
  #   extensions - Array of extnames
  #   charset    - Default Encoding or function to detect encoding
  #
  # Returns Hash.
  # attr_reader :mime_types

  #
  # attr_reader :mime_exts

  registerMimeType: !(mime_type, options || {}) ->
    const extnames = options.extensions.map (extname) ->
      # Sprockets::Utils.normalize_extension(extname)
      extname

    {charset} = options
    # charset ||= EncodingUtils::DETECT if mime_type.start_with?('text/')

    extnames.forEach !(extname) ->
      @_mime_exts[extname] = mime_type
    , @

    @_mime_types[mime_type] = do
      extensions: extnames
      charset: charset if charset

  mimeTypeForExtname: (extname) ->
    @_mime_exts[extname] or 'application/octet-stream'


  extnameForMimeType: (mime_type) ->
    @_mime_types[mime_type].extensions.0

  # Public: Test mime type against mime range.
  #
  #    match_mime_type?('text/html', 'text/*') => true
  #    match_mime_type?('text/plain', '*') => true
  #    match_mime_type?('text/html', 'application/json') => false
  #
  # Returns true if the given value is a mime match for the given mime match
  # specification, false otherwise.
  matchMimeType: (value, matcher) ->
    const [v1, v2] = value.split '/', 2
    const [m1, m2] = matcher.split '/', 2

    (m1 is '*' or v1 is m1) and (not m2 or m2 is '*' or m2 is v2)
