$(document).on('ready page: load', function() {
	console.log('step1');
  $('table tbody tr').click(function(){
    $(this).toggleClass('active');
    var hiddenField = $('#hiddeninv').val();
    var mydata = $('data-inventory-part-id').data();
  });
  console.log('step2');
	$("#paymentInstructionsFrame-lightbox-preview").click(function(){
		var url = $(this).attr("data-url");
		armor.openModal(url);
	});
	console.log('end');
});



