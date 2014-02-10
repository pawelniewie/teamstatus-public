$(function() {
	if (!mixpanel) return;

	mixpanel.track_links(".navbar a.btn", "Clicked Nav Button");
	mixpanel.track_links(".navbar a.menu-item", "Clicked Nav Link");
	mixpanel.track_links('.social-media a', "Clicked Social Link");
	mixpanel.track_links('.contact-block a', "Clicked Contact Link");
	mixpanel.track_links('footer a', "Clicked Footer Link");
	mixpanel.track_links('a.top-link', 'Back to top');
});