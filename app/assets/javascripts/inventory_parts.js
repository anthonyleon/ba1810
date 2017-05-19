$(document).on('ready page:load', function() {
  $('#sweet_inventory').on('click', function() {
    swal({
        title: "Inventory Upload",
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
});
