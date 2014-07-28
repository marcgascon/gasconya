angular.module('ptasksApp', [])
  .controller('formValues', ['$scope', function($scope) {
	
	$scope.languages= [	{text: "Spanish", val: "SP"},
						{text: "English", val: "EN"},
						{text: "French", val: "FR"},
						{text: "Italian", val: "IT"},
						{text: "German", val: "GE"}
					];

	$scope.subtitles_coding = [	{text: "UTF-8", val: "utf8"},
								{text: "ISO-8859-15", val: "iso-8859-15"},
								{text: "Latin1", val: "latin1"}
					  		];
}]);