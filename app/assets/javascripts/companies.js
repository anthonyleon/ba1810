$(document).on('ready page:load', function() {
  return CountryStateSelect({
    country_id: "company_country",
    state_id: "company_state"
  });
});


$(document).on('ready page:load', function(){
  $('#dashboard-auctions>div:visible').hide();

  $('.nav-option').click(function() {
    $(this).addClass('active');
    $(this).siblings('.nav-option').removeClass('active');

    var num = $(this).attr('id');
    $('#dashboard-auctions>div').hide();
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
    };
  });
  // default tab is 2
  $('.nav-option[id="2"').click();
});

$(function() {
  $("#salesPartsDT").DataTable();
  $("#purchaseDT").DataTable();

});


           