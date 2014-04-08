(function() {
  window.BuildCtrl = function($scope, $http) {
    $scope.ok = true;
    return $scope.buildIt = function() {
      return $http.post('/app', {}).then(response)(function() {
        return console.log(response.body);
      });
    };
  };

}).call(this);
