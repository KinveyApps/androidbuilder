window.BuildCtrl = ($scope, $http) ->

  $scope.buildIt = () ->
    $http.post('/app', {}).then(response) -> 
      console.log response.body
