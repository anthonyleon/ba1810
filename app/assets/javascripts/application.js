//= require jquery
//= require jquery_ujs
//= require sweetalert
//= require jquery.turbolinks
//= require_tree .

String.prototype.capitalize = function() {
  return this.charAt(0).toUpperCase() + this.slice(1);
}


$(document).ready(function() {
  var dataBehavior = function(data, message) {
    $(data).on("click", function(e){
      e.preventDefault();
      var self = this;
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
              self.parentElement.parentElement.remove()
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


  $('#invetoryPartsDT').dataTable({
    "aoColumns": [
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": true },
      { "bSortable": false },
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
      { "bSortable": false }
    ]
  });
  $('#mybidsDT').dataTable({
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
})


//= require turbolinks
