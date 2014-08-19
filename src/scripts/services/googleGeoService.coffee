class Service
	constructor: ($resource) ->

		activity = $resource 'http://maps.googleapis.com/maps/api/geocode/json'

		self =
			location: ''
	
		self.getAddress = (coords)->
			promise = activity.get({latlng: coords.latitude + ',' + coords.longitude}).$promise
			promise.then (response)->
				location = result for result in response.results when (result.types.indexOf('street_address') > -1)
				if location
					self.location = location.formatted_address
				else
					self.location = response.results[0].formatted_address if response.results.length > 0

		return self

angular.module('app').service 'googleGeoService', ['$resource', Service]
