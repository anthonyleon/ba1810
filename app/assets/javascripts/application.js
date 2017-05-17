//= require jquery
//= require jquery_ujs
//= require sweetalert
//= require jquery.turbolinks
//= require chosen-jquery
//= require country_state_select
//= require maskedinput
//= require maskmoney
//= require bootstrap.min
//= require_directory .
//= require_directory ./limitless
//= require dataTable/dataTable_basic.js
//= stub landing






$(document).ready(function() {


  var $flashTransition = $('.flash-transition');
  if (!!$flashTransition.length > 0) {
    $('.flash-transition').css({
      'color': 'white',
      '-webkit-transition': '1.2s',
      'transition': '1.2s',
      'height': '40px',
      'margin': '10px auto'
    })
  }
  setTimeout(function(){
    $('.flash-transition').height(0);
    $('.flash-transition').text("");
  },3500)
})

String.prototype.capitalize = function() {
  return this.charAt(0).toUpperCase() + this.slice(1);
}


$(document).ready(function() {
  var dataBehavior = function(data, message) {
    $(data).on("click", function(e){
      e.preventDefault();
      var self = $(this);
      swal({
        title: "Are you sure?",
        text: "You will not be able to recover this "+ message + ".",
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "Yes, delete it!",
        cancelButtonText: "No, cancel!",
        closeOnConfirm: false,
        closeOnCancel: false,
      },
      function(isConfirm){
        if (isConfirm) {
          $.ajax({
            url: $(self).attr("href"),
            dataType: "JSON",
            method: "DELETE",
            success: function() {
              swal("Deleted!", "" + message.capitalize() + " Deleted.", "success");
              // ge the tr to delete
              // debugger;
              self.closest('tr').remove();
            }
          });
        } else {
          swal("Cancelled", "Your " + message + " was not deleted!", "error");
        }
      });
    });
  };

// card edit slide up and down functions on auction/destination
  $('.card-edit').click(function(){
    $('.card.destination-address').addClass('large');
      //this method increases the height to 72px
  });

  $('.card-edit-remove').click(function(){
    $('.card.destination-address.large').removeClass('large');
      //this method increases the height to 72px
  });

  dataBehavior("[data-inventory-behavior='delete']", "part");
  dataBehavior("[data-buyer-auctions-behavior='delete']", "auction");
  dataBehavior("[data-current-opportunities-behavior='delete']", "auction");
  dataBehavior("[data-auction-bid-behavior='delete']", "bid");
  dataBehavior("[data-engine-behavior='delete']", "engine");
  dataBehavior("[data-aircraft-behavior='delete']", "aircraft");
  dataBehavior("[data-company-purchase-behavior='delete']", "company");
  dataBehavior("[data-invited-auction-behavior='delete'", "opportunity");

$('#engineDTDashBoard').dataTable({
    "aoColumns": [
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": false }
    ]
  });


  $('#projectDT').dataTable({
      "aoColumns": [
        { "bSortable": true },
        { "bSortable": true },
        { "bSortable": true },
        { "bSortable": true },
        { "bSortable": true },
        { "bSortable": true },
        { "bSortable": true },
        { "bSortable": false }
      ]
    });



  // $('#buyerAuctionsDT').dataTable({
  //   "aoColumns": [
  //     { "bSortable": true },
  //     { "bSortable": true },
  //     { "bSortable": true },
  //     { "bSortable": true },
  //     { "bSortable": true },
  //     { "bSortable": true },
  //     { "bSortable": true },
  //     { "bSortable": false }
  //   ],
  //   "columnDefs": [{ "width": "80px", "targets": 8 }]
  // });



  $('#mybidsDT').dataTable({
    "aoColumns": [
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": false}
    ]
  });

  $('#currentOpportunitiesDT').dataTable({
    // "processing": true,
    // "serverSide": true,
    // "ajax": $('#currentOpportunitiesDT').data('source'),
    // "pageLength": 10,
    "aoColumns": [
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true }
    ]
  });

  $('#pendingPurchasesDT').dataTable({
    "aoColumns": [
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true}
    ]
  });

// ADMIN DATATABLES
  $('#allInventoryDT').dataTable({
    "processing": true,
    "serverSide": true,
    "ajax": $('#allInventoryDT').data('source'),
    "pageLength": 50,
    "aoColumns": [
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true }
    ]
  });

  $('#matchedAuctionsDT').dataTable({
    "processing": true,
    "serverSide": true,
    "ajax": $('#matchedAuctionsDT').data('source'),
    "pageLength": 50,
    "order": [[5, "desc"]],
    "aoColumns": [
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true }
    ]
  });

  $('#allAuctionsDT').dataTable({
    "pageLength": 50,
    "processing": true,
    "serverSide": true,
    "order": [[5, "desc"]],
    "ajax": $('#allAuctionsDT').data('source'),
    "aoColumns": [
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true }
    ]
  });

  $('#unmatchedAuctionsDT').dataTable({
    "processing": true,
    "serverSide": true,
    "ajax": $('#unmatchedAuctionsDT').data('source'),
    "pageLength": 50,
    "order": [[5, "desc"]],
    "aoColumns": [
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true }
    ]
  });

});


//= require turbolinks
