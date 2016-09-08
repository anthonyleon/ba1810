//= require jquery
//= require jquery_ujs
//= require sweetalert
//= require jquery.turbolinks
//= require chosen-jquery
//= require country_state_select
//= require_tree .


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

  dataBehavior("[data-inventory-behavior='delete']", "part");
  dataBehavior("[data-buyer-auctions-behavior='delete']", "auction");
  dataBehavior("[data-current-opportunities-behavior='delete']", "auction");
  dataBehavior("[data-auction-bid-behavior='delete']", "bid");
  dataBehavior("[data-engine-behavior='delete']", "engine");
  dataBehavior("[data-aircraft-behavior='delete']", "aircraft");
  dataBehavior("[data-company-purchase-behavior='delete']", "company");

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


  // $('#aircraftDT').dataTable({
  //   "aoColumns": [
  //     { "bSortable": true },
  //     { "bSortable": true },
  //     { "bSortable": true },
  //     { "bSortable": true },
  //     { "bSortable": true },
  //     { "bSortable": true },
  //     { "bSortable": true },
  //     { "bSortable": false }
  //   ]
  // });

  $('#invetoryPartsDT').dataTable({
    "processing": true,
    "pageLength": 10,
    "aoColumns": [
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": false }
    ]
  });

  $('#buyerAuctionsDT').dataTable({
    "aoColumns": [
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": false },
    ],
    "columnDefs": [{ "width": "80px", "targets": 7 }]
  });
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

});


//= require turbolinks
