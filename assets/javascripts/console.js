//= require global.js
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
				description: "Add a clock",
				widgetSettings: {
					title: "Clock"
				}
			},
			{
				name: "STFU",
				id: "stfu",
				description: "Tell your team to be quiet",
				widgetSettings: {
					title: "Shhh..."
				}
			},
			{
				name: "Bamboo Builds",
				id: "bamboo-builds",
				description: "Get Bamboo Builds status",
				configurable: true,
				widgetSettings: {
					title: "Builds"
				}
			},
			{
				name: "JIRA Counter",
				id: "jira-simple-counter",
				description: "Display number of issues in JIRA",
				configurable: true,
				widgetSettings: {
					title: "Issues"
				}
			},
			{
				name: "JIRA Issues",
				id: "jira-issue-list",
				description: "Display list of issues from JIRA",
				configurable: true,
				widgetSettings: {
					title: "Issues"
				}
			},
			{
				name: "Static HTML",
				id: "static-html",
				description: "Display static HTML",
				configurable: true,
				widgetSettings: {
					title: "HTML"
				}
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

var WidgetsCtrl = ['$scope', '$routeParams', '$log', '$http', '$window', 'path', 'widgets', 'board',
	function($scope, $routeParams, $log, $http, $window, path, widgets, board) {
	$scope.widgets = widgets;
	$scope.board = board;
	$scope.$on('$routeChangeSuccess', routeChanged);

	routeChanged();

	function routeChanged() {
		var widgets = $scope.widgets;
		var widgetId = $routeParams.id;

		_.each(widgets, function(widget) {
			widget['active'] = !!widget['id'] && widget['id'] === widgetId;
			if(widget.active) {
				$scope.currentWidget = widget;
				$scope.$broadcast('currentWidgetChanged', $scope.currentWidget);
			}
		});
	}
}];

var WidgetCtrl = ['$scope', '$http', '$compile', '$window', 'path', 'widgets', function($scope, $http, $compile, $window, path, widgets) {
	$scope.$on('currentWidgetChanged', function(event, widget) {
		widgetChanged(widget);
	});

	if ($scope.currentWidget !== undefined) {
		widgetChanged($scope.currentWidget);
	}

	function widgetChanged(widget) {
		$scope.settings = {};
		$scope.widgetSettings = widget.widgetSettings || { title: "Widget" };
		if (widget.configurable) {
			$http.get(path + "/ajax/integrations/" + widget.id + "/js").success(function (data) {
				eval.apply(window, [data]);
				$http.get(path + "/ajax/integrations/" + widget.id).success(function (data) {
					angular.element('.settings').html($compile(data)($scope));
					$scope.settings = {};
				});
			});
		}
	}

	$scope.addWidget = function() {
		$http.post(path + '/ajax/board/' + $scope.board.publicId + '/widgets', {
			widget: $scope.currentWidget.id,
			settings: $scope.settings,
			widgetSettings: $scope.widgetSettings
		}).success(function(data) {
			if (!data.error) {
				$window.location.href=$scope.board.editUrl;
			}
		});
	};
}];
