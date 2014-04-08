express = require 'express';
less = require 'less-middleware'
coffeescript = require('connect-coffee-script')
app = express();
templates = require './gen'

app.configure ->
	app.use(less({ src: __dirname + '/../client/' }));
	app.use coffeescript(src: __dirname + '/../client/')
	app.use('/components', express.static(__dirname + '/../bower_components/'))
	app.use express.static __dirname + '/../client/'
	app.use app.router

	app.use (err, req, res, next)->
		if err.isError?
			res.send(err.statusCode,{
				type: err.type
				description: err.description
				stack: err.stack
			})
		else
			res.send(500,err)
	
app.post '/app', (req, res, next) -> 
	# res.download('./glittercorn.jpg')

	res.send(templates.render())

app.get '*', (req, res, next) ->
	res.render('../client/templates/layout.jade')

server = app.listen 3000, ->
 	console.log('Listening on port %d', server.address().port)
