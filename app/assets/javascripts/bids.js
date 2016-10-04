
$("a[data-remote]").on("ajax:success", function (e, data, status, xhr){
  console.info(data,e,status);
});

$(document).on('ready page: load', function() {
	$("#paymentInstructionsFrame-lightbox-preview").click(function(){
		var url = $(this).attr("data-url");
		armor.openModal(url);
	});
	console.log('end');
	

	$(".destination").hide();
	$(".armor-modal").hide();
	$(".freight_num").hide();
	$(".shipping_account").hide();
	$(".proceed").hide();
	$(".po_num").hide();


	$("#confirm-shipping").click(function(){
		$("#confirm-shipping").hide(100);
		$(".shipping_account").show(100);
		$("#this-address").hide(100);
		$(".destination").show(200);
	});

	$(".submit_button").click(function(){
		$(".destination").hide(200);
		$(".po_num").show(100);
	});

	$(".checkbox").click(function(){
		$(".freight_num").toggle(200);
	});

	$(".confirm_cost").click(function(){
	  $(".costs").hide(200);
	});

	$(".po_submit").click(function(){
		$(".proceed").show(100);
		$(".po_num").hide(100);
		$(".freight_num").hide(100);
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

