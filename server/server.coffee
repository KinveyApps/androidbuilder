 # Copyright (c) 2014, Kinvey, Inc. All rights reserved.

 # This software is licensed to you under the Kinvey terms of service located at
 # http://www.kinvey.com/terms-of-use. By downloading, accessing and/or using this
 # software, you hereby accept such terms of service  (and any agreement referenced
 # therein) and agree that you have read, understand and agree to be bound by such
 # terms of service and are of legal age to agree to such terms with Kinvey.

 # This software contains valuable confidential and proprietary information of
 # KINVEY, INC and is subject to applicable licensing agreements.
 # Unauthorized reproduction, transmission or distribution of this file and its
 # contents is a violation of applicable laws.

express = require 'express';
less = require 'less-middleware'
coffeescript = require('connect-coffee-script')
app = express()
code_generator = require './gen'

context1 = {app_kid: "kid_TV5e-30yni", app_secret: "3e43e8ca6e9c4a7998320b6c9d6cc1cf", app_name:"MyApp", collection_name: "MyCollection", entity_class_name: "MyEntityName", entity_fields: [{name: "a", type: "String"}]}
platform1 = 'android'

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
	app.use express.bodyParser()
	app.use(less({ src: __dirname + '/../client/' }));
	app.use coffeescript(src: __dirname + '/../client/')
	app.use('/components', express.static(__dirname + '/../bower_components/'))
	app.use express.static __dirname + '/../client/'
	app.use app.router

	app.use (err, req, res, next)->
		if err
			return returnError err, 'use', res 

app.post '/app', (req, res, next) -> 
	console.log 'Post handling. -> ' + req.body
	code_generator.cleanupSync()
	code_generator.gen req.body, req.body.platform, (err) -> 
		console.log('Gen Response')
		if err
			console.log 'Code_generator.gen error', err
			return returnError err, 'gen', res

		code_generator.zip req.body.platform, (err, filename) -> 
			if err
				console.log 'Code_generator.zip error', err
				return returnError err, 'zip', res

			console.log 'archive completed, return 200'
			console.log filename

			res.send {"download": filename}

			# return res.download filename, 'karp.zip', (err) ->
			# 	console.log err


app.get '/android', (req, res, next) ->
	res.render('../client/templates/androidlayout.jade')

app.get '/ios', (req, res, next) ->
	res.render('../client/templates/ioslayout.jade')

app.get '/file/:id', (req, res, next) ->
	res.download(process.env.PWD + '/' +req.params.id)

app.get '*', (req, res, next) ->
	res.render('../client/templates/androidlayout.jade')


server = app.listen 3000, ->
	console.log('Listening on port %d', server.address().port)
