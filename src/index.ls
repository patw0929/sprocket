require! {
  nconf
}

require! {
  Sprocket: './sprocket'
}
module.exports = CoC

CoC <<< {Sprocket}
/*
 * Convention over Configuration
 */
function CoC
  nconf.env!argv!.defaults do
    NODE_ENV: 'development'

  new Sprocket do
    environment: do
      basePath: 'tmp/public'
      javascriptsRelativePath: 'assets'
      stylesheetsRelativePath: 'assets'
  #
  .registerHandler 'javascripts' <[ ls ]> require('./sprocket/ext/ls')
  .registerHandler 'javascripts' <[ js ]> require('./sprocket/ext/js')
  #
  .registerHandler 'stylesheets' <[ scss sass ]> require('./sprocket/ext/scss')
  .registerHandler 'stylesheets' <[ css ]> require('./sprocket/ext/css')
