module.exports = {
  registerMimeType: function(mimeType, options){
    var extnames, charset;
    options || (options = {});
    extnames = options.extensions.map(function(extname){
      return extname;
    });
    charset = options.charset;
    extnames.forEach(function(extname){
      this._mime_exts[extname] = mimeType;
    }, this);
    this._mime_types[mimeType] = {
      extensions: extnames,
      charset: charset ? charset : void 8
    };
  },
  mimeTypeForExtname: function(extname){
    return this._mime_exts[extname] || 'application/octet-stream';
  },
  extnameForMimeType: function(mimeType){
    return this._mime_types[mimeType].extensions[0];
  },
  matchMimeType: function(value, matcher){
    var ref$, v1, v2, m1, m2;
    ref$ = value.split('/', 2), v1 = ref$[0], v2 = ref$[1];
    ref$ = matcher.split('/', 2), m1 = ref$[0], m2 = ref$[1];
    return (m1 === '*' || v1 === m1) && (!m2 || m2 === '*' || m2 === v2);
  }
};