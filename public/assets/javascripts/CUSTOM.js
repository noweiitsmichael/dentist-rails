$(function() {

  $(".recommendations-day").click( function() {
    console.log("CLICK!");
    $(".arrow-down").hide();
    console.log($(this).siblings());
    $(this).siblings().children().show();
    $(".rec-panel").slideUp("fast").delay( 300 );
    $(".rec-" + $(this).attr("day")).slideDown("fast");
  });
});