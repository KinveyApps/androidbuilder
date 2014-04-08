jinjs = require('jinjs').registerExtension('.tpl');
java_model_template = require('./content_root/android/java_model_class');
fs = require('fs')

render = ->
	context =  { package_name: "package com.pkg;\n", _imports_: ["import new1;", "import new2;"], class_name: "MyClassName" };
	result = java_model_template.render(context);	
	fs.mkdir './gen', (err) ->
		if (err)
			throw err;
		
		fs.writeFile './gen/MyClassName.java', result, (err) ->
			if (err)
				throw err;
			console.log('It\'s saved!');
			return result;

exports.render = render