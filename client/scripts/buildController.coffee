window.BuildCtrl = ($scope, $http) ->

<<<<<<< HEAD
  $scope.buildIt = () ->
    $http.post('/app', {}).then(response) -> 
      console.log response.body
=======
	console.log "huh"

	$scope.buildIt = () =>
		console.log "ok"
		$http.post('/app', {}).then (response) ->
			console.log response.body

>>>>>>> 6e833be829d83b9266648168c32acc432aaa7f4e
