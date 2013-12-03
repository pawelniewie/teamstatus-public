$(document).ready(function() {
  $("#signup .loading").hide();
  $("form").submit(function(e) {
    $("#notices div").hide();
    e.preventDefault();

    if ($("form input#email").val() === "") {
      $("#notices #error").show();
    } else {
      $("#signup .loading").show();
      $.post("/signup", $(this).serialize(), function() {
        $("#signup .loading").hide();
        $("#notices #success").show();
        $("form input#email").val("");
      })
      .error(function() {
        $("#signup .loading").hide();
        $("#notices #error").show();
      });
    }
  });
});