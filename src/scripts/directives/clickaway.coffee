class Directive
	constructor: ($document) ->
		doc = $document[0]
		body = angular.element doc.body
		lastClickedElement = null

		link = (scope, element, attrs) ->
			element.bind 'click', (e) ->
				sameElement = element is lastClickedElement

				if lastClickedElement and not sameElement
					el = angular.element(lastClickedElement)
					lastClickedElementScope = el.isolateScope() or el.scope() # check the isolate scope first
					callback = lastClickedElement[0]?.getAttribute('app-clickaway')
					lastClickedElementScope.$eval callback if lastClickedElementScope
			
				lastClickedElement = element
				e.stopPropagation()

			clickEventHandler = ->
				# dont handle body clicks if there is no active popovers
				# return if not lastClickedElement
				
				clickAwayCallback = attrs.appClickaway
				scope.$eval clickAwayCallback

				# reset last clicked popovers since they all off now
				# lastClickedElement = null

				return true

			body.bind 'click', clickEventHandler

			# Destroy clean up
			scope.$on '$destroy', ->
				body.unbind 'click', clickEventHandler

		return {
			link
			restrict: 'A'
		}

angular.module('app').directive 'appClickaway', ['$document', Directive]