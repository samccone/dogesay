require('coffee-script')

/**
 * Module dependencies.
 */

var express = require('express'),
    routes  = require('./routes/index'),
    http    = require('http'),
    roots   = require('roots-express'),
    assets  = require('connect-assets'),
    path    = require('path');


var app = express();
roots.add_compiler(assets);

app.configure(function(){
  app.set('port', process.env.PORT || 1236);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(assets());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.static(path.join(__dirname, 'public')));
  app.use(app.router);
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

routes.set(app);

var server = http.createServer(app).listen(app.get('port'), function(){
  console.log("Server listening on port " + app.get('port') + "\n Control + C to stop");
});

roots.watch(server);
