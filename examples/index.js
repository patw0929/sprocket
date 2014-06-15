var connect = require('connect');
var PORT = process.env.PORT || 5000;
var NODE_ENV = process.env.NODE_ENV || 'development';
/*
 * start a static file server
 */
var server = connect()
  .use(connect['static']('public', {
    maxAge: Infinity
  }));
if ('production' !== NODE_ENV) {
  server.use(connect['static']('tmp/public'));
}
server.listen(PORT, function () {
  console.log("Connect server in " + NODE_ENV + " started at PORT " + PORT);
});
