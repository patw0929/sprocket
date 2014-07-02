module.exports = {
  registerTemplate: function(ext, templateFn){
    this.templates[ext] = templateFn;
  }
};