$(document).on('ready page:load', function() {
  $('#about').click(function() {
    $('.about').fadeIn();
  });
  $('.close').click(function() {
    $('.about').fadeOut();
  });
});
