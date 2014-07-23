module.exports = {
  registerTemplate: function(ext, templateFn){
    this._templates[ext] = templateFn;
  }
};