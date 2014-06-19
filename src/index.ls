require! {
  Sprocket: './sprocket'
}
module.exports = CoC

CoC <<< {Sprocket}
/*
 * Convention over Configuration
 */
function CoC
  new Sprocket!
  #
  .registerHandler 'javascripts' <[ ls ]> require('./sprocket/ext/ls')
  .registerHandler 'javascripts' <[ js ]> require('./sprocket/ext/js')
  #
  .registerHandler 'stylesheets' <[ less ]> require('./sprocket/ext/less')
  .registerHandler 'stylesheets' <[ scss sass ]> require('./sprocket/ext/scss')
  .registerHandler 'stylesheets' <[ css ]> require('./sprocket/ext/css')
