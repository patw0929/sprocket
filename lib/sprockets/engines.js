module.exports = {
  registerEngine: function(ext, engineFn, options){
    var that;
    this.engines[ext] = engineFn;
    if (that = options.mime_type) {
      this.engine_extensions[ext] = this.mime_types[that].extensions[0];
    }
  }
};