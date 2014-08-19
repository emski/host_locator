class Directive
	constructor: () ->
		link = (scope, element, attrs) ->

			scope.$watch 'coords', (val)->
				return if not val
				renderMap val, scope.title
			, true
			
			renderMap = (coords, title)->
				latLang = new google.maps.LatLng coords.latitude, coords.longitude
				options =
					zoom: 11
					center: latLang
					mapTypeId: google.maps.MapTypeId.ROADMAP
				
				# load the map
				map = new google.maps.Map(element[0], options)

				# add marker
				marker = new google.maps.Marker { position: latLang,  map: map, title:title}

		return {
			link
			restrict: 'EA'
			template: '<div></div>'
			transclude: true
			scope:
				coords: '='
				title: '='


		}

angular.module('app').directive 'appMap', [Directive]
