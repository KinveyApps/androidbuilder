(function() {
  window.BuildCtrl = function($scope, $http) {
    $scope.ok = true;
    return $scope.buildIt = function() {
      return console.log("Ok");
    };
  };

}).call(this);
