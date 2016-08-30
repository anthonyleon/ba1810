$(document).on('ready page: load', function() {
	$("#paymentInstructionsFrame-lightbox-preview").click(function(){
		var url = $(this).attr("data-url");
		armor.openModal(url);
	});
	console.log('end');

	$(".destination").hide();
	$(".armor-modal").hide();
	$(".freight_num").hide();

	$(".checkbox").click(function(){
		$(".freight_num").toggle(200);
		$(".send_ship_num").click(function(){
			$(".freight_num").hide(200);
		});

	});

	$("#this-address").click(function(){
		$("#this-address").hide();
		$(".ui-action-small").show();
		$("#change-address").click(function(){
			$(".ui-action-small").hide();
		});
	});

	$("#change-address").click(function(){
		$("h6").hide(100);
		$("#change-address").hide(100);
		$("#this-address").hide(100);
		$(".destination").show(200);
	});

	$(".submit_button").click(function(){
		$(".destination").hide(200);
		$(".ui-action-small").show();
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

