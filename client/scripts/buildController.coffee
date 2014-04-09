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

	$scope.buildIt = () =>
		console.log "building model"
		console.log $scope.fieldList
		payload =
			app_kid: $scope.appKey
			app_secret: $scope.appSecret
			app_name: $scope.appName
			collection_name: $scope.collectionName
			entity_class_name: $scope.entityName
			entity_fields: $scope.fieldList
		console.log payload

		$http.post('/app', payload).then (response) ->
			window.location = '/file/' + response.data.download;