jinjs = require('jinjs').registerExtension('.tpl')

java_model_tpl_en = '/Entity_java'
java_model_tpl_bn = '/hihimanu/src/com/kinvey/hihimanu'
java_model_tpl = require './content_root/android' + java_model_tpl_bn + java_model_tpl_en
java_strings_tpl_en = '/strings_xml'
java_strings_tpl_bn = '/hihimanu/res/values'
java_strings_tpl = require './content_root/android' + java_strings_tpl_bn + java_strings_tpl_en
java_kinvey_props_tpl_en = '/kinvey_properties'
java_kinvey_props_tpl_bn = '/hihimanu/assets'
java_kinvey_props_tpl = require './content_root/android' + java_kinvey_props_tpl_bn + java_kinvey_props_tpl_en
java_templates = [{template: java_model_tpl, basename: java_model_tpl_bn, ename: java_model_tpl_en}, 
	{template: java_strings_tpl, basename: java_strings_tpl_bn, ename: java_strings_tpl_en},
	{template: java_kinvey_props_tpl, basename: java_kinvey_props_tpl_bn, ename: java_kinvey_props_tpl_en}]

fs = require 'fs'
nodePath = require 'path'
wrench = require 'wrench'
pwd = process.env.PWD

archiver = require 'archiver'

target_dir = pwd 
gen_dir = 'gendir'
archive = archiver 'zip'

gen = (context, callback) ->
	console.log 'started gen'
	
	src_dir = nodePath.join pwd, '/server/content_root/android'
	dest_dir = nodePath.join pwd, gen_dir
	wrench.copyDirRecursive src_dir, dest_dir, (err) ->
		if err
			console.log 'wrench.copyDirRecursive', err
			return callback err	

		errored = false

		for tpl in java_templates
			do (tpl) ->
				wrench.mkdirSyncRecursive nodePath.join pwd + gen_dir + tpl.basename
				console.log 'Made path: ', nodePath.join pwd + gen_dir + tpl.basename
				result = tpl.template.render(context);
				console.log tpl.basename
				if tpl.basename == java_model_tpl_bn
					console.log nodePath.join gen_dir + tpl.basename + "/" + context.entity_class_name + ".java"
					path = nodePath.join gen_dir + tpl.basename + "/" + context.entity_class_name + ".java"
				else
					console.log gen_dir + tpl.basename + tpl.ename.replace("_",".")
					path = gen_dir + tpl.basename + tpl.ename.replace("_",".")
				fs.writeFile path, result, (err) ->
					if err
						errored = true
						console.log 'completed gen with failure on path: ', path
						return callback err

		if !errored
			console.log 'completed gen'
			console.log typeof callback
			callback()

zip = (callback) ->
	target_filename = 'android-' + guid() + '.zip'
	output = fs.createWriteStream target_filename

	output.on "close", ->
		console.log archive.pointer() + " total bytes"
		console.log "archiver has been finalized and the output file descriptor has closed."
		callback null, nodePath.join pwd, target_filename

	archive.on "error", (err) ->
		console.log 'in zip ' + err
		callback err

	archive.pipe output
	archive.bulk [
		expand: true
		cwd: nodePath.join gen_dir, 'hihimanu'
		src: ['**']
		dest: 'hihimanu'
		filter: tplExtFilter
	]
	archive.finalize()

tplExtFilter = (path) ->
	if path.indexOf('.tpl') > 0
		return false	
	return true

guid = ->
	now = new Date()
	return Math.floor(Math.random() * 10) + parseInt(now.getTime()).toString(36).toUpperCase()

cleanupSync = ->
	path = nodePath.join pwd, gen_dir
	return deleteFolderRecursiveSync (path)

deleteFolderRecursiveSync = (path) ->
	if fs.existsSync(path)
		fs.readdirSync(path).forEach (file, index) ->
			curPath = path + "/" + file
			if fs.lstatSync(curPath).isDirectory() # recurse
				deleteFolderRecursiveSync curPath
			else # delete file
				fs.unlinkSync curPath

		fs.rmdirSync path
	return

exports.gen = gen
exports.zip = zip
exports.cleanupSync = cleanupSync

