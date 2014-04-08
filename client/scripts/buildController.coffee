window.BuildCtrl = ($scope, $http) ->
	$scope.buildIt = () =>
		console.log "ok"
		$http.post('/app', {}).then (response) ->
			console.log response.body
