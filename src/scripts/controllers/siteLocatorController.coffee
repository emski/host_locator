class Controller
	
	constructor: ($scope, $window, $timeout, googleGeoService, hostLookupService, hostValidationService) ->
		$scope.isError = false
		$scope.errorMessage = ''
		$scope.currentLocation = null
		$scope.currentAddress = ''
		$scope.searchLocation = null
		$scope.locationName = ''
		$scope.search = ''

		$scope.searchHost = ()->
			resetError()

			if !($scope.search.replace ' ','')
				setError 'Please provide host name or IP address'
				return

			if !(hostValidationService.validate $scope.search)
				setError 'You have provided invalid host / IP address'
				return

			hostLookupService.getHostLocation($scope.search).then (response)->
				if not response.latitude and not response.longitude
					return setError 'Are you searching for localhost? Please provide valid external IP address'

				$scope.searchLocation = response
				$scope.locationName = $scope.search
			, (error)->
				setError 'The third party service has returned error: ' + error.data + ' Btw, I have noticed that sometimes it works with IP Addresses only'

		geoSuccessCallback = (position)->
			$scope.$apply ->
				$scope.currentLocation = position.coords
				$scope.searchLocation = position.coords
				$scope.locationName = 'Your Current Location'

			googleGeoService.getAddress(position.coords).then ->
				$scope.currentAddress = googleGeoService.location

		geoErrorCallback = (error)->
			#setError ()
		
		setError = (message)->
			$scope.errorMessage = message
			$scope.isError = true
		
		resetError = ->
			$scope.errorMessage = ''
			$scope.isError = false


		geolocation = $window.navigator.geolocation

		if geolocation
			geolocation.getCurrentPosition geoSuccessCallback, geoErrorCallback
		else
			setError 'This browser that you are using does not support geolocation feature'


angular.module('app').controller 'siteLocatorController', ['$scope', '$window', '$timeout', 'googleGeoService', 'hostLookupService', 'hostValidationService', Controller]
