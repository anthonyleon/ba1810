$(document).on('ready page: load', function() {
  console.log('ready');
    $('table tbody tr').click(function(){

      $(this).parent().children().removeClass('active');
      $(this).addClass('active');

      var hiddenField = $('#hiddeninv').val();
      var mydata = $('data-inventory-part-id').data();

    });
});
