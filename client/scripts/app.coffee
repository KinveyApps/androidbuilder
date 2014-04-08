angular.module("Application", ['ngRoute'])
.config ($routeProvider, $locationProvider, $httpProvider)->
  $httpProvider.defaults.useXDomain = true
  delete $httpProvider.defaults.headers.common['X-Requested-With']

  $locationProvider.html5Mode(true)
  $routeProvider
    .when('/', {controller: BuildCtrl, templateUrl:'/'})
    .otherwise({})

.run ($rootScope)->
  $rootScope.isViewLoading = false
  $rootScope.$on '$routeChangeStart', ()->
    $rootScope.isViewLoading = true

  $rootScope.$on '$routeChangeSuccess', ()->
    $rootScope.isViewLoading = false

  $rootScope.$on '$routeChangeError', ()->
    console.log arguments
    $rootScope.isViewLoading = false
