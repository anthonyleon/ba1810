$(document).on('ready page: load', function() {
  console.log('ready');
    $('table tbody tr').click(function(){
      console.log(this);
      $(this).addClass('active');
      console.log('click');
      var hiddenField = $('#hiddeninv').val();
      var mydata = $('data-inventory-part-id').data();
      console.log(hiddenField);
    });
});
