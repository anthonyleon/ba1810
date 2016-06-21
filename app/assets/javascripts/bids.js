$(document).on('ready page: load', function() {
  $('table tbody tr').click(function(){
    $(this).toggleClass('active');
    var hiddenField = $('#hiddeninv').val();
    var mydata = $('data-inventory-part-id').data();
  });
});
