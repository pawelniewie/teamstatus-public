widget = {
	//runs when we receive data from the job
	onData: function (el, data) {
		var fadeParams = {duration: 3000, easing: 'linear'};

		function startStfu() {
			$('.stfu-off').fadeOut(fadeParams);
			$('.stfu-on').fadeIn(fadeParams);
		}

		function stopStfu() {
			$('.stfu-on').fadeOut(fadeParams);
			$('.stfu-off').fadeIn(fadeParams);
		}

		function refreshDate() {
			if (data.isStfu) {
				startStfu();
			} else {
				stopStfu();
			}
		}

		refreshDate();
	}
};