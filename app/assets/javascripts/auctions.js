
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
  		console.log('TWO');
  		row.cells[num_columns - 3].style.display = '';
  		row.cells[num_columns - 2].style.display = '';
  		row.cells[num_columns - 1].style.display = 'none';
	});

	$('.record-btn').click( function(){
			console.log('THREE');
  		var row = event.target.parentElement.parentElement.parentElement;
  		var num_columns = row.cells.length;
  		row.cells
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
  		return element.parent().remove();
	};
});
