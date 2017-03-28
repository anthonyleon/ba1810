
$(document).on('ready page:load', function() {
	// $('.auction-destination').hide();
	// $('#shipping-destination-box').click(function() {
	// 	$('.auction-destination').trigger("reset");
	// });

	$('.card-edit-submit').click(function(){
		$('.confirm-address-bubble').removeClass('active');
		$('.confirm-address-bubble').addClass('visited');
	});

	$('.card-edit-remove').click(function(){
		$('.card.destination-address.large').removeClass('large');
    //this method increases the height to 72px
  	});

  	$('.edit-address').click(function(){
  		$('.edit-shipping').show(350);
  	});

  	$('#add-supplier-circle').click(function(){
  		$('.supplier-field').append($('.container.add-new-supplier').html);
  	});

	$("#addNewSupplier").on("click", function() {
	  $("#add-new-supplier").append($("#new-supplier-partial").html());
	});

	this.removeSupplier = function(element) {
  		return element.parent().remove();
	};
});
