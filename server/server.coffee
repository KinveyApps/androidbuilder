express = require 'express';
less = require 'less-middleware'
coffeescript = require('connect-coffee-script')
app = express();

app.configure ->
	app.use(less({ src: __dirname + '/../client/' }));
	app.use('/components', express.static(__dirname + '/../bower_components/'))
	app.use coffeescript(src: __dirname + '/../client/')
	app.use express.static __dirname + '/../client/'
	 
app.get '/', (req, res)->
  res.render('../client/templates/layout.jade')

server = app.listen 3000, ->
  console.log('Listening on port %d', server.address().port)