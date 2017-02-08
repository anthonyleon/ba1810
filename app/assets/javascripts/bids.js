
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
	".shipping-acct-btn",
	".proceed",
	".purchase-order-confirmation",
	"#import-btn"
	]
	.forEach(function(f) {
		$(f).hide();
	});

	// Update PO Num, then 'proceed'
	$('.po-submit').click(function() {
		var transactionId = $(this).data().transactionId;
		var poNum = $('#po_num').val();
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


	$(".submit_button, .card-edit-submit").click(function(){
		$(".purchase-order-confirmation").show(100);
		$(".destination-form").hide(200);
		$(".card-edit-submit").hide(200);
		$(".card-edit").hide(200);
	});

	$(".card-edit-submit, .submit_button").click(function(){
		$('li.confirm-address-bubble.active').removeClass("active").addClass("visited");
		$('li.generate-po-bubble.next').removeClass("next").addClass("active");
	});

	$('Confirm Purchase Order').click(function(){
		$('li.generate-po-bubble.next').removeClass("active").addClass("visited");
		$('li.generate-invoice-bubble.next').removeClass("next").addClass("active");
	});

//START shipping account option in step 4 after seller invoices
	$(".checkbox").click(function(){
		$(".freight_num").toggle(200);
		$(".shipping-acct-btn").toggle(200);
	});

	$(".confirm_cost").click(function(){
		$(".costs").hide(200);
	});
	$(".shipping-acct-btn").click(function(){
		$(".freight_num, .shipping-acct-btn, .shipping_account").hide(200);
	})
//END

	// choosing inventory in bid
	$( ".choose-inventory" ).click(function() {
		id = $(this).closest("tr").data("inventory-part-id");
		$(this).toggleClass("selected");
	});

	// collect all the selected table rows into an array
	var tableRow = document.getElementsByClassName("choose-inventory");
	var ids = [];

	function toggleArrayItem(arr, item) {
	    var i = arr.indexOf(item);
	    if (i === -1)
	        arr.push(item);

	    else
	        arr.splice(i,1);
	    
	   	$('#hiddeninv').val(ids);
	}

	for (var i = 0; tableRow; i++) {
		tableRow[i].addEventListener('click', function() { 
			toggleArrayItem(ids, id);

			
		}, false);
	};



  //format dollars
	$(".dollars").maskMoney({prefix:'$ ', thousands:',', decimal:'.', affixesStay: true});
	$(".percentage").maskMoney({suffix:'% ', decimal:'.', affixesStay: true});
  // $(".dollars").maskMoney('mask', 0.00);
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

// inventory part new page
  $('select').material_select();
  $('#file').click(function(){
    $('#import-btn').show(200);
  });

});


