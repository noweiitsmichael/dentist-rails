$(function() {

  $(".recommendations-day").click( function() {
    $(".arrow-down").hide();
    $(this).siblings().children().show();
    $(".rec-panel").animate({opacity: 0}, 300).delay(100).hide();
    $(".rec-" + $(this).attr("day")).animate({opacity: 1}, 300).show();
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