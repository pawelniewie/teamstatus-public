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

var AddWidgetCtrl = ['$scope', '$log', '$http', '$location', 'path', 'widgets', function($scope, $log, $http, $location, path, widgets) {
	$scope.widgets = widgets;
	$scope.$on('$routeChangeSuccess', function () {
      var widgets = $scope.widgets;
      var path = $location.path();

      for (var i = 0; i < widgets.length; i++) {
          var widget = widgets[i];
          var href = '/' + widget['id'];
          widget['active'] = !!href && href === path;
      }
  });
}];

var WidgetCtrl = ['$scope', '$routeParams', 'widgets', function($scope, $routeParams, widgets) {
	$scope.widget = _.find(widgets, function(widget) { return widget.id == $routeParams.id; });
}];