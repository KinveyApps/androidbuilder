express = require 'express';
less = require 'less-middleware'
coffeescript = require('connect-coffee-script')
app = express()
code_generator = require './gen'

context1 = {app_kid: "kid1234", app_secret: "myappsecret", app_name:"MyApp", collection_name: "MyCollection", entity_class_name: "MyEntityName", entity_fields: [{name: "a", type: "String"}]}


returnError = (err, context, res) ->
	console.log context + ': ' + err
	if err?.isError?
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
		if err
			return returnError err, 'use', res 

app.post '/app', (req, res, next) -> 
	console.log 'Post handling.'
	code_generator.cleanupSync()
	code_generator.gen context1, (err) -> 
		console.log('Gen Response')
		if err
			console.log 'Code_generator.gen error', err
			return returnError err, 'gen', res

		code_generator.zip (err, filename) -> 
			if err
				console.log 'Code_generator.zip error', err
				return returnError err, 'zip', res

			console.log 'archive completed, return 200'
			console.log filename

			return res.download(filename)
	
app.get '*', (req, res, next) ->
	res.render('../client/templates/androidlayout.jade')

app.get '/android', (req, res, next) ->
	res.render('../client/templates/androidlayout.jade')

app.get '/ios', (req, res, next) ->
	res.render('../client/templates/ioslayout.jade')

server = app.listen 3000, ->
	console.log('Listening on port %d', server.address().port)
