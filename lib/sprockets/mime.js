module.exports = {
  registerMimeType: function(mime_type, options){
    var extnames, charset;
    options || (options = {});
    extnames = options.extensions.map(function(extname){
      return extname;
    });
    charset = options.charset;
    extnames.forEach(function(extname){
      this.mime_exts[extname] = mime_type;
    }, this);
    this.mime_types[mime_type] = {
      extensions: extnames,
      charset: charset ? charset : void 8
    };
  },
  mimeTypeForExtname: function(extname){
    return this.mime_exts[extname] || 'application/octet-stream';
  },
  extnameForMimeType: function(mime_type){
    return this.mime_types[mime_type].extensions[0];
  },
  matchMimeType: function(value, matcher){
    var ref$, v1, v2, m1, m2;
    ref$ = value.split('/', 2), v1 = ref$[0], v2 = ref$[1];
    ref$ = matcher.split('/', 2), m1 = ref$[0], m2 = ref$[1];
    return (m1 === '*' || v1 === m1) && (!m2 || m2 === '*' || m2 === v2);
  }
};