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
# fse = require 'fs-extra'
wrench = require 'wrench'
pwd = process.env.PWD

archiver = require 'archiver'
target_filename = 'target.zip'
target_dir = pwd 
gen_dir = pwd + '/gendir'
output = fs.createWriteStream target_filename
archive = archiver 'zip'

gen = (callback) ->
	console.log 'started gen'

	context = {app_kid: "kid1234", app_secret: "myappsecret", app_name:"MyApp", collection_name: "MyCollection", entity_class_name: "MyEntityName"}
	wrench.copyDirRecursive pwd + '/server/content_root/android', gen_dir, {filter:'*.tpl'}, (err) ->
	  callback err	if err

		for tpl in java_templates
			do (tpl) ->		
				wrench.mkdirSyncRecursive gen_dir + tpl.basename
				result = tpl.template.render(context);
				path = gen_dir + tpl.basename + tpl.ename.replace("_",".")
				fs.writeFile path, result, (err) ->
					callback err if err

		console.log 'completed gen'
		callback

zip = (callback) ->
	output.on "close", ->
	  console.log archive.pointer() + " total bytes"
	  console.log "archiver has been finalized and the output file descriptor has closed."
  	callback null, target_filename

	archive.on "error", (err) ->
	  callback err

	archive.pipe output
	archive.bulk [
	  expand: true
	  cwd: gen_dir
	  src: ["**"]
	  dest: target_dir
	]
	archive.finalize()

# cleanup = (callback) ->
# 	if fs.existsSync(target_dir + target_filename)
# 		fs.unlinkSync pwd + target_dir + target_filename 
# 	deleteFolderRecursive pwd + gen_dir
# 	callback

# deleteFolderRecursive = (path) ->
#   files = []
#   if fs.existsSync(path)
#     files = fs.readdirSync(path)
#     files.forEach (file, index) ->
#       curPath = path + "/" + file
#       if fs.lstatSync(curPath).isDirectory() # recurse
#         deleteFolderRecursive curPath
#       else # delete file
#         fs.unlinkSync curPath
#     fs.rmdirSync path

exports.gen = gen
exports.zip = zip
# exports.cleanup = cleanup