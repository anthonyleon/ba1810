$('.card-edit-submit').click(function(){
  $('.confirm-address-bubble').removeClass('active');
  $('.confirm-address-bubble').addClass('visited');
});

$('.card-edit-remove').click(function(){
  $('.card.destination-address.large').removeClass('large');
    //this method increases the height to 72px
});
