function fadeInAuction(num) {
  switch(num) {
    case "2":
      $('#buyer-auctions').fadeIn();
      break;
    case "3":
      $('#supplier-auctions').fadeIn();
      break;
    case "4":
      $('#possible-auctions').fadeIn();
      break;
    case "5":
      $('#inactive-auctions').fadeIn();
      break;
  }
}

$(document).on('ready page:load', function(){
  $('.nav-option').click(function() {
    $(this).addClass('active');
    var num = $(this).attr('id');
    $(this).siblings('.nav-option').each(function() {
      $(this).removeClass('active');
    });
    $('#dashboard-auctions div:visible').fadeOut(fadeInAuction(num));
  });
});
