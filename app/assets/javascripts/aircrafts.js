$(function() {
  var is_available = $('#is_available');
  var promise = new Promise(function(resolve, reject) {
    var is_available = $('#is_available');
    resolve(is_available);
  });

  promise.then(function(value) {
    value.val()
    if( value.val() != "true" || value.length == 0 ){
      $('.is_th').remove();
      console.log("DONE");
    }
  $('#aircraftDTIndex').DataTable();

  }, function(reason) {
    console.log(reason); // Error!
  });

});
