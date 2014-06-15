var Sprocket;
Sprocket = require('./sprocket');
module.exports = CoC;
CoC.Sprocket = Sprocket;
/*
 * Convention over Configuration
 */
function CoC(){
  return new Sprocket().registerHandler('javascripts', ['ls'], require('./sprocket/ext/ls')).registerHandler('javascripts', ['js'], require('./sprocket/ext/js')).registerHandler('stylesheets', ['scss', 'sass'], require('./sprocket/ext/scss')).registerHandler('stylesheets', ['css'], require('./sprocket/ext/css'));
}