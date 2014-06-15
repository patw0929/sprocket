var connect = require('connect');
var nconf = require('nconf');

nconf.env().argv().defaults({
  NODE_ENV: 'development',
  PORT: 5000
});

var server = connect()
  .use(connect['static']('public', {
    maxAge: Infinity
  }));
if ('production' !== nconf.get('NODE_ENV')) {
  server.use(connect['static']('tmp/public'));
}
server.listen(nconf.get('PORT'), function () {
  console.log("Connect server in " + nconf.get('NODE_ENV') +
    " started at PORT " + nconf.get('PORT'));
});
