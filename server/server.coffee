express = require 'express';
less = require 'less-middleware'
coffeescript = require('connect-coffee-script')
app = express();
templates = require './render'

app.configure ->
	app.use(less({ src: __dirname + '/../client/' }));
	app.use('/components', express.static(__dirname + '/../bower_components/'))
	app.use coffeescript(src: __dirname + '/../client/')
	app.use express.static __dirname + '/../client/'

app.post '/app', (req, res, next)->
	# res.download('./glittercorn.jpg')
	res.send(templates.render())

app.get '/', (req, res, next)->
	res.render('../client/templates/layout.jade')

server = app.listen 3000, ->
	console.log('Listening on port %d', server.address().port)
