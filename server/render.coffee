jinjs = require('jinjs').registerExtension('.tpl');
java_model_template = require('./content_root/android/java_model_class');

render = ->
	context =  { package_name: "package com.pkg;\n", _imports_: ["import new1;", "import new2;"], class_name: "MyClassName" };
	result = java_model_template.render(context);	
	return result;

exports.render = render