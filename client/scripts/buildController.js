(function() {
  window.BuildCtrl = function($scope, $http) {
    var _this = this;
    console.log("huh");
    return $scope.buildIt = function() {
      console.log("ok");
      return $http.post('/app', {}).then(function(response) {
        return console.log(response.body);
      });
    };
  };

}).call(this);
