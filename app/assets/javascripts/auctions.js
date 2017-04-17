
$(document).on('ready page:load', function() {
	// $('.auction-destination').hide();
	// $('#shipping-destination-box').click(function() {
	// 	$('.auction-destination').trigger("reset");
	// });
	$('.responsive-remove-btn').hide();
	$('.purchase-btns').hide();

	$('.remove-btn').click( function(){
		
		var row = event.target.parentElement.parentElement.parentElement.parentElement;
  		var num_columns = row.cells.length;
  		// row.cells
  		console.log(row);
  		row.cells[num_columns - 3].style.display = '';
  		row.cells[num_columns - 2].style.display = '';
  		row.cells[num_columns - 1].style.display = 'none';
	});
	
	$('.record-btn').click( function(){
  		var row = event.target.parentElement.parentElement.parentElement;
  		var num_columns = row.cells.length;
  		row.cells
  		console.log(row.cells);
  		row.cells[num_columns - 3].style.display = 'none';
  		row.cells[num_columns - 2].style.display = 'none';
  		row.cells[num_columns - 1].style.display = "";
  		// row.deleteCell(num_columns-1);
  		// num_columns = row.cells.length;
  		// row.deleteCell(num_columns-1);

  		// num_columns = row.cells.length;
  		// var newRow = row.insertCell(num_columns);
  		// newRow.innerHTML = "HTLM"

  		// // $('.responsive-remove-btn').show()

  		// console.log("happening")

	});

	

	// $('.responsive-remove-btn').hide();
	// $('#b-div').hide();
	// $('.record-btn').click(function(){
	//     $('.record-btn').toggle(500);
	//     if($('.responsive-remove-btn').is(":visible"))
	//         $('.responsive-remove-btn').hide();

	// });
	// $('#b').click(function(){
	//     $('.responsive-remove-btn').toggle(500);
	//     if($('.record-btn').is(":visible"))
	//         $('.record-btn').hide();
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


  	var addSupplier = document.getElementById("addNewSupplier");
	$("#addNewSupplier").on("click", function() {
		addSupplier.innerHTML = "Add Another Supplier";
		$("#add-new-supplier").append($("#new-supplier-partial").html());
	});

	this.removeSupplier = function(element) {
		counter--;
  		return element.parent().remove();
	};
});
