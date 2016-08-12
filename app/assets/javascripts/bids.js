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



