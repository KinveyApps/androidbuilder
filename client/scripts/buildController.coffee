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

window.BuildCtrl = ($scope, $http, $location, $anchorScroll) ->

# context1 = {app_kid: "kid1234", app_secret: "myappsecret", app_name:"MyApp", collection_name: "MyCollection", entity_class_name: "MyEntityName", 


	# entity_fields: [{name: "a", type: "String"}, {...}]

# }

	# $scope.appName = ""
	$scope.appKey = ""
	# $scope.appSecret = ""
	# $scope.collectionName = ""
	# $scope.entityClassName = ""
	$scope.fieldList = [{
		name: ""
		type: ""
	}]


	$scope.addField = () ->
		$scope.fieldList.push
			name: ""
			type: ""
		# $scope.currentType = ""
		# $scope.currentField = ""
		# console.log $scope.fieldList
		#reset $scope fields

	$scope.jumpDown = (target) ->
		console.log "jumping"
		$location.hash(target)
		$anchorScroll
		# $window.scrollTo 0, $window.height + $document.body.scrollTop

	$scope.buildIt = (plat) =>
		console.log "building model"
		console.log $scope.fieldList
		payload =
			app_kid: $scope.appKey
			app_secret: $scope.appSecret
			app_name: $scope.appName
			collection_name: $scope.collectionName
			entity_class_name: $scope.entityName
			entity_fields: $scope.fieldList
			platform: plat
		console.log payload

		$http.post('/app', payload).then (response) ->
			window.location = '/file/' + response.data.download;