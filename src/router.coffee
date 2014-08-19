angular.module('app').config [
	'$routeProvider'
	($routeProvider) ->
		$routeProvider
		.when('/',
			templateUrl: 'views/lookup.html'
			controller: null
			reloadOnSearch: false
		).otherwise(redirectTo: '/')
]