var con = angular.module('teamstatus.console', ['ngRoute'])
	.constant('path', '/console');

var JiraCtrl = ['$scope', '$log', '$http', '$window', 'path', function($scope, $log, $http, $window, path) {
	$http.get(path + "/ajax/jiraServer").success(function(data) {
		$scope.jira = data;
	});

	$scope.saveJira = function() {
		$scope.saved = false;
		$scope.sending = true;
		$http.post(path + "/ajax/jiraServer", $scope.jira).success(function(data) {
			$scope.saved = true;
			$scope.sending = false;
			$scope.jira = data;
		}).error(function(data) {
			$scope.sending = false;
		});
	};
}];

angular.module('teamstatus.console.widget', ['teamstatus.console'])
	.directive('bsHolder', function() {
		return {
			link: function (scope, element, attrs) {
				Holder.run({images: element.get(0)});
			}
		};
	})
	.factory('board', ['$document', function($document) {
		return {
			editUrl: angular.element('meta[name="ts.board.editUrl"]').attr('content'),
			publicId: angular.element('meta[name="ts.board.publicId"]').attr('content')
		};
	}])
	.factory('widgets', ['$http', function($http) {
		return [
			{
				name: "Clock",
				id: "clock",
				description: "Add a clock"
			},
			{
				name: "STFU",
				id: "stfu",
				description: "Tell your team to be quiet"
			}
		];
	}])
	.config(['$routeProvider', 'path', function($routeProvider, path) {
		$routeProvider.when('/welcome', {
			templateUrl: path + '/partials/add-widget-welcome'
		}).when('/:id', {
			templateUrl: path + '/partials/add-widget-form',
			controller: 'WidgetCtrl'
		}).otherwise({
			redirectTo: '/welcome'
		});
	}]);

var AddWidgetCtrl = ['$scope', '$log', '$http', '$location', '$window', 'path', 'widgets', 'board',
	function($scope, $log, $http, $location, $window, path, widgets, board) {
	$scope.widgets = widgets;
	$scope.settings = {};
	$scope.board = board;
	$scope.$on('$routeChangeSuccess', function () {
			var widgets = $scope.widgets;
			var path = $location.path();

			_.each(widgets, function(widget) {
				var href = '/' + widget['id'];
				widget['active'] = !!href && href === path;
				if(widget.active) {
					$scope.currentWidget = widget;
				}
			});
	});
	$scope.addWiget = function() {
		$http.post(path + '/ajax/board/' + $scope.board.publicId + '/widgets', {widget: $scope.currentWidget.id, settings: $scope.settings}).success(function(data) {
			if (!data.error) {
				$window.location.href=$scope.board.editUrl;
			}
		});
	};
}];

var WidgetCtrl = ['$scope', '$routeParams', 'widgets', function($scope, $routeParams, widgets) {
}];