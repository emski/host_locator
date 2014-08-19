class Service
	constructor: ($resource) ->

		activity = $resource 'http://freegeoip.net/json/:host', host: @host

		self = {}
		self.getHostLocation = (host)->
			promise = activity.get({host}).$promise

		return self

angular.module('app').service 'hostLookupService', ['$resource', Service]