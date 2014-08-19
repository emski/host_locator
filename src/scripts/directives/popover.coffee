class Directive
	constructor: ($window, $document) ->
		doc = $document[0]

		controller = ['$scope', '$element', '$attrs', '$transclude', ($scope, $element, $attrs, $transclude) ->
			body = angular.element doc.body
		]

		link = (scope, element, attrs) ->
			scope.showPopover = false

			attrs.$observe 'show', (val) ->
				boolVal = scope.$eval(val)

				if boolVal
					# recalculate positioning if showing
					calculatePositioning(element, scope)
				else
					# otherwise, reset positioning
					scope.showUpwards = false
					element.css 'top', ''
					element.find('.popover-wrap').css 'top', ''

				scope.showPopover = boolVal
		
		calculatePositioning = ($element, scope) ->
			parentWidth = $element[0].parentElement.clientWidth
			parentHeight = $element[0].parentElement.clientHeight
			contentElement = $element[0].querySelector('.popover-wrap')
			
			# get sizing object
			boundingClientRect = getElementBoundingClientRect $element, contentElement
			
			# assign left (or right <- TODO:MM)
			contentWidth = boundingClientRect.width
			if scope.right?
				angular.element(contentElement).css 'right', scope.right

			else if scope.left?
				angular.element(contentElement).css 'left', scope.left
			else
				positionLeft = (parentWidth - contentWidth) / 2
				positionLeft = 10 if scope.float is 'left'
				angular.element(contentElement).css 'left', positionLeft + 'px'


			if scope.forceBottom?
				angular.element(contentElement).css 'top', ''
				scope.showUpwards = false
				return false

			# assign top or bottom
			scope.showUpwards = $window.innerHeight < (boundingClientRect.top + boundingClientRect.height)

			if scope.top?
				angular.element(contentElement).css 'top', scope.top
				scope.showUpwards = false
			else if scope.showUpwards
				angular.element(contentElement).css 'top', -1*(boundingClientRect.height + parentHeight) + 'px'
			else
				angular.element(contentElement).css 'top', ''


		# gets element width and height by swapping
		# display and visibility styles
		getElementBoundingClientRect = (element, contentElement) ->
			# change display to 'hide' and visibility to 'hidden'
			element.css('visibility', 'hidden')
			element.removeClass('ng-hide')

			# get sizing object
			boundingClientRect = contentElement.getBoundingClientRect()

			# swap display and visibility back
			element.addClass('ng-hide')
			element.css('visibility', '')
			boundingClientRect


		return {
			link
			controller
			restrict: 'E'
			replace: true
			templateUrl: 'views/directives/popover.html'
			transclude: true
			scope: {
				float: '@'
				right: '@'
				left: '@'
				top: '@'
				forceBottom: '@'
			}
		}

angular.module('app').directive 'appPopover', ['$window', '$document', Directive]
