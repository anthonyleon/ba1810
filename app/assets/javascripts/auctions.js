$(document).on('change', ':file', function() {
		var input = $(this),
				numFiles = input.get(0).files ? input.get(0).files.length : 1,
				label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
		input.trigger('fileselect', [numFiles, label]);
});
$(document).on('ready page:load', function() {
	// $('.auction-destination').hide();
	// $('#shipping-destination-box').click(function() {
	// 	$('.auction-destination').trigger("reset");
	// });

	// add more suppliers on auctions/show
	$('.submit-added-suppliers').hide();
	$('.add-supplier-after').click( function() {
		$('.submit-added-suppliers').slideDown( "slow", function () {

		});
	});
	$(".submit-added-suppliers").click( function() {
		console.log("yo");
		$(".more-suppliers-form").toggle( "drop" );
	});

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

	$(':file').on('fileselect', function(event, numFiles, label) {
			console.log(numFiles);
			console.log(label);
			document.getElementById("file-name").innerHTML = numFiles + " File(s) Selected";
			$('button:submit').attr('disabled',false);
			// or, as has been pointed out elsewhere:
			// $('input:submit').removeAttr('disabled');

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

	// add supplier in auctions/_form
	var addSupplier = document.getElementById("addNewSupplier");
	$("#addNewSupplier").on("click", function() {

		addSupplier.innerHTML = "Add Another Supplier";
		$("#add-new-supplier").append($("#new-supplier-partial").html());
		$("#add-new-supplier .add-supplier-partial").last().hide().slideDown( "slow", function () {

		});
	});

	this.removeSupplier = function(element) {
		return element.parent().remove();
	};

	$('#sweet_basic').on('click', function() {
		swal({
				title: "Contact Info",
				text: "Send us an e-mail with your updated inventory at support@bid.aero",
				confirmButtonColor: "#2196F3",
				type: "info"
		});
		});
		$('#sweet_opportunities').on('click', function() {
		swal({
				title: "Inventory Upload",
				text: "Keep your opportunities current! \n Send us an e-mail with your updated inventory at \n\nsupport@bid.aero\n",
				confirmButtonColor: "#2196F3",
				type: "info"
		});
	});


	// cool mutation class for actively listening to when html elements move. couldn't use it where I wanted to here

	// // purchase confirmation hide submit button
	// var element = document.querySelector('.po-confirm-wzrd-btn');
	// var observer = new MutationObserver(function(mutations) {
	// 	mutations.forEach(function(mutation) {
	// 		if (mutation.target.value == "Submit") {
	// 			$('.po-confirm-wzrd-btn').hide();
	// 		} else {
	// 			$('.po-confirm-wzrd-btn').show();
	// 		}
	// 	});
	// });
	// observer.observe(element, {
	// 	attributes: true //configure it to listen to attribute changes
	// });
});
