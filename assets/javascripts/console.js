var con = angular.module('teamstatus.console', []);

var JiraCtrl = ['$scope', '$log', '$http', '$location', function($scope, $log, $http, $location) {
	$scope.saveJira = function() {
		$scope.sending = true;
		$http.post("/console/ajax/jiraServer", $scope.jira).then(function(response) {
			$scope.sending = false;
			$location.path("/console/boards");
		});
	};
}];