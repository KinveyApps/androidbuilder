(function() {
  angular.module("Application", ['ngRoute']).config(function($routeProvider, $locationProvider, $httpProvider) {
    $httpProvider.defaults.useXDomain = true;
    delete $httpProvider.defaults.headers.common['X-Requested-With'];
    $locationProvider.html5Mode(true);
    return $routeProvider.when('/', {
      controller: BuildCtrl,
      templateUrl: '/'
    }).otherwise({});
  }).run(function($rootScope) {
    $rootScope.isViewLoading = false;
    $rootScope.$on('$routeChangeStart', function() {
      return $rootScope.isViewLoading = true;
    });
    $rootScope.$on('$routeChangeSuccess', function() {
      return $rootScope.isViewLoading = false;
    });
    return $rootScope.$on('$routeChangeError', function() {
      console.log(arguments);
      return $rootScope.isViewLoading = false;
    });
  });

}).call(this);
