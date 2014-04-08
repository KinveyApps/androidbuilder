window.BuildCtrl = ($scope, $http) ->
  $scope.ok = true

  $scope.buildIt = () ->
    $http.post('/app', {}).then(response) -> 
      console.log response.body
