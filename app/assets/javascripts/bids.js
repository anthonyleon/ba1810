
$("a[data-remote]").on("ajax:success", function (e, data, status, xhr){
  console.info(data,e,status);
});

$(document).on('ready page:load', function() {
	$("#paymentInstructionsFrame-lightbox-preview").click(function(){
		var url = $(this).attr("data-url");
		armor.openModal(url);
	});
	console.log('end');

	[
		".armor-modal",
		".freight_num",
		".proceed",
		".purchase-order-confirmation"
	]
	.forEach(function(f) {
		$(f).hide();
	});

	// Update PO Num, then 'proceed'
	$('.po-submit').click(function() {
		var transactionId = $(this).data().transactionId;
		var poNum = $('.purhcase-order-confirmation #po_num').val();
		$.ajax({
			url: '/update_transaction/' + transactionId,
			method: 'PATCH',
			data: {
				transaction: {
					po_num: poNum
				}
			}
		})
		.success(function(data){
			console.log('here');
		})
		.fail(function(jqXHR, textStatus, errorThrown){
			console.log(jqXHR, textStatus, errorThrown);
		})
		.always(function(data){
			$('.purhcase-order-confirmation #po_num').val(" ");
			window.location = '/purchase/' + transactionId + '/buyer_purchase';
		});
	});

  $('.collapsible').collapsible({
    accordion : false // A setting that changes the collapsible behavior to expandable instead of the default accordion style
  });



	// $("#confirm-shipping").click(function(){
	// 	$("#confirm-shipping").hide(100);
	// 	$(".shipping_account").show(100);
	// 	$("#this-address").hide(100);
	// 	$(".destination").show(200);
	// });

	$(".submit_button, .card-edit-submit").click(function(){
    $(".purchase-order-confirmation").show(100);
		$(".destination-form").hide(200);
    $(".card-edit-submit").hide(200);
    $(".card-edit").hide(200);
	});

  $('button.btn.custom-btn.card-edit-submit').click(function(){
    $('li.confirm-address-bubble.active').removeClass("active").addClass("visited");
    $('li.generate-po-bubble.next').removeClass("next").addClass("active");
  });

  $('Confirm Purchase Order').click(function(){
    $('li.generate-po-bubble.next').removeClass("active").addClass("visited");
    $('li.generate-invoice-bubble.next').removeClass("next").addClass("active");
  });

  $(".checkbox").click(function(){
		$(".freight_num").toggle(200);
	});

	$(".confirm_cost").click(function(){
	  $(".costs").hide(200);
	});
});


// $(document).on('click', 'table tbody tr', function(){
//   $(this).toggleClass('active');

//   var self = $(this),
//       hiddenField = $('#hiddeninv').val(),
//       url = self.data('url');

//   $.ajax({
//     url: url,
//     type: 'POST',
//     dataType: 'JSON',
//     data: { param1: 'value1' },
//   })
//   .done(function(data) {
//     console.log("success");
//   });

// });
