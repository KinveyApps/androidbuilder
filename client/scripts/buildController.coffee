window.BuildCtrl = ($scope, $http) ->

	console.log "huh"

	$scope.buildIt = () =>
		console.log "ok"
		$http.post('/app', {}).then (response) ->
			console.log response.body

