
$("a[data-remote]").on("ajax:success", function (e, data, status, xhr){
  console.info(data,e,status);
});

$(document).on('ready page:load', function() {
	$(".paymentInstructionsFrame-lightbox-preview").click(function(){
		var url = $(this).attr("data-url");
		armor.openModal(url);
	});
	console.log('end');

	[
		".armor-modal",
		".freight_num",
		".proceed",
		".purhcase-order-confirmation"
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


	// $("#confirm-shipping").click(function(){
	// 	$("#confirm-shipping").hide(100);
	// 	$(".shipping_account").show(100);
	// 	$("#this-address").hide(100);
	// 	$(".destination").show(200);
	// });

	$(".submit_button").click(function(){
		$(".destination").hide(200);
		$(".purhcase-order-confirmation").show(100);
	});

	$(".checkbox").click(function(){
		$(".freight_num").toggle(200);
	});

	$(".confirm_cost").click(function(){
	  $(".costs").hide(200);
	});

	// format dollars on place new bid
  $( ".choose-inventory" ).click(function() {
    id = $(this).closest("tr").data("inventory-part-id");
    $(this).addClass("selected").siblings().removeClass("selected");
    $('#hiddeninv').val(id);
  });


  $(".dollars").maskMoney({prefix:'$ ', thousands:',', decimal:'.', affixesStay: true});
  $(".percentage").maskMoney({suffix:'% ', decimal:'.', affixesStay: true});
  $(".dollars").maskMoney('mask', 0.00);
  $(function(){
      $("form").submit(function() {
      	// in bid/new.html.haml
          $('#part-price').val($('#part-price').maskMoney('unmasked')[0]);
          $('#est-shipping').val($('#est-shipping').maskMoney('unmasked')[0]);
        // in seller_purchase.html.haml
        	$('#finalized-shipping').val($('#finalized-shipping').maskMoney('unmasked')[0]);
        	$('#tax-rate').val($('#tax-rate').maskMoney('unmasked')[0]);

      });
  });


});


