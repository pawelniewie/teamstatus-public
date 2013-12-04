$(function() {
	$('footer a').click(function () {
		mixpanel && mixpanel.track('Footer clicked', {'Destination' : $(this).attr('href')});
	});
});