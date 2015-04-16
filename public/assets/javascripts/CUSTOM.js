$(function() {

  $(".recommendations-day").click( function() {
    $(".arrow-down").hide();
    $(this).siblings().children().show();
    $(".rec-panel").slideUp("fast").delay( 300 );
    $(".rec-" + $(this).attr("day")).slideDown("fast");
  });

  $(".recommendation input[type=checkbox]").click( function() {
    var value = +($(this).parent().parent().find(".improvement-amount").html());
    console.log(value);
    if ( $(this).attr("checked") === "checked" ) {

      console.log("Subtracting" + value);
      value = value + +($(this).val());
    } else {
      value = value - +($(this).val());
    }
    $(this).parent().parent().find(".improvement-amount").html(value);
  });
});