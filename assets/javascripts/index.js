$(function() {
	if (mixpanel) {
		mixpanel.track("Home");
		$('.container.marketing a[data-mixpanel]').click(function() {
			mixpanel.track('Sign up clicked', {'Selected flavor' : $(this).data('mixpanel')});
		});
	}
});