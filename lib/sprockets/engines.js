module.exports = {
  registerEngine: function(ext, engineFn, options){
    var that;
    this._engines[ext] = engineFn;
    if (that = options.mimeType) {
      this._engine_extensions[ext] = this._mime_types[that].extensions[0];
    }
  }
};