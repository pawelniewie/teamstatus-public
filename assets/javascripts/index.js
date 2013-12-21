//= require global.js
$(function() {
	if (mixpanel) {
		mixpanel.track("Home");
	}

	$("#signup .loading").hide();

	$("form").submit(function(e) {
		$("#notices .error").hide();
		$("#notices .success").hide();

		e.preventDefault();

		if(mixpanel) {
			mixpanel.track('Subscribe clicked', {'Email' : $("form input#email").val()});
		}

		if ($("form input#email").val() === "") {
			$("#notices .error").show();
		} else {
			$("#signup .loading").show();
			$.post("/signup", $(this).serialize(), function() {
				FB.init({
						xfbml      : true  // parse XFBML
				});

				$("#signup .loading").hide();
				$("#notices .success").show();
				$("form input#email").val("");
			})
			.error(function() {
				$("#signup .loading").hide();
				$("#notices .error").show();
			});
		}
	});
});