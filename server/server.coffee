express = require 'express';
less = require 'less-middleware'
coffeescript = require('connect-coffee-script')
app = express();
code_generator = require './gen'

returnError = (err, context, res) ->
	console.log context + ': ' + err
	if err.isError?
		res.send(err.statusCode,{
			type: err.type
			description: err.description
			stack: err.stack
		})
	else
		res.send(500, err)

app.configure ->
	app.use(less({ src: __dirname + '/../client/' }));
	app.use coffeescript(src: __dirname + '/../client/')
	app.use('/components', express.static(__dirname + '/../bower_components/'))
	app.use express.static __dirname + '/../client/'
	app.use app.router

	app.use (err, req, res, next)->
		returnError err, 'use', res if err


app.post '/app', (req, res, next) -> 
	# code_generator.cleanup ->		
	code_generator.gen (err) -> 
		returnError err, 'gen', res if err

		code_generator.zip (err, filename) -> 
			returnError err, 'zip', res if err

			console.log 'archive completed, return 200'
			return res.download(filename)
	
app.get '*', (req, res, next) ->
	res.render('../client/templates/layout.jade')

server = app.listen 3000, ->
 	console.log('Listening on port %d', server.address().port)
