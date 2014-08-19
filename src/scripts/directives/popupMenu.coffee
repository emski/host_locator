class Directive
	constructor: ->
		link = (scope, element, attrs) ->
			scope.showContent = scope.showContent or false

			scope.toggle = ->
				scope.showContent = !scope.showContent

			scope.close = ->
				scope.$apply ->
					scope.showContent = false

			scope.onClick = (item)->
				scope.toggle()

		return {
			link
			restrict: 'E'
			replace: true
			transclude: true
			templateUrl: 'views/directives/popup-menu.html'
			scope: {}
		}

angular.module('app').directive 'popupMenu', [Directive]