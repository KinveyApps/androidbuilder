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


ios_appdelegate_tpl_en = '/AppDelegate_m'
ios_appdelegate_tpl_bn = '/TestDrive-iOS-master/KinveyQuickstart'
ios_appdelegate_tpl = require './content_root/ios' + ios_appdelegate_tpl_bn + ios_appdelegate_tpl_en
ios_modelh_tpl_en = '/TestObject_h'
ios_modelh_tpl_bn = '/TestDrive-iOS-master/KinveyQuickstart'
ios_modelh_tpl = require './content_root/ios' + ios_modelh_tpl_bn + ios_modelh_tpl_en
ios_modelm_tpl_en = '/TestObject_m'
ios_modelm_tpl_bn = '/TestDrive-iOS-master/KinveyQuickstart'
ios_modelm_tpl = require './content_root/ios' + ios_modelm_tpl_bn + ios_modelm_tpl_en
ios_templates = [{template: ios_appdelegate_tpl, basename: ios_appdelegate_tpl_bn, ename: ios_appdelegate_tpl_en}, 
	{template: ios_modelh_tpl, basename: ios_modelh_tpl_bn, ename: ios_modelh_tpl_en},
	{template: ios_modelm_tpl, basename: ios_modelm_tpl_bn, ename: ios_modelm_tpl_en}]


fs = require 'fs'
nodePath = require 'path'
wrench = require 'wrench'
pwd = process.env.PWD

archiver = require 'archiver'

target_dir = pwd 
gen_dir = 'gendir'
archive = archiver 'zip'

gen = (context, platform, callback) ->
	console.log 'started gen -> ' + context
	
	src_dir = nodePath.join pwd, '/server/content_root/' + platform
	dest_dir = nodePath.join pwd, gen_dir
	wrench.copyDirRecursive src_dir, dest_dir, (err) ->
		if err
			console.log 'wrench.copyDirRecursive', err
			return callback err	

		errored = false

		if platform == 'android'
			platform_specific_templates = java_templates
		else 
			platform_specific_templates = ios_templates

		for tpl in platform_specific_templates
			do (tpl) ->
				wrench.mkdirSyncRecursive nodePath.join pwd + gen_dir + tpl.basename
				result = tpl.template.render(context);
				if tpl.ename == java_model_tpl_en
					path = nodePath.join gen_dir + tpl.basename + "/" + context.entity_class_name + ".java"
				else if tpl.ename == ios_modelm_tpl_en
					path = nodePath.join gen_dir + tpl.basename + "/" + context.entity_class_name + ".m"
				else if tpl.ename == ios_modelh_tpl_en
					path = nodePath.join gen_dir + tpl.basename + "/" + context.entity_class_name + ".h"
				else
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

zip = (platform, callback) ->
	target_filename = platform + '-' + guid() + '.zip'
	output = fs.createWriteStream target_filename

	output.on "close", ->
		console.log archive.pointer() + " total bytes"
		console.log "archiver has been finalized and the output file descriptor has closed."
		callback null, nodePath.join target_filename

	archive.on "error", (err) ->
		console.log 'in zip ' + err
		callback err

	archive.pipe output
	archive.bulk [
		expand: true
		cwd: nodePath.join gen_dir
		src: ['**']
		dest: platform
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

