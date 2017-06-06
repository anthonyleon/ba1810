$(function() {
  var promise = new Promise(function(resolve, reject) {
    var is_available = $('#is_available_aircraft');
    resolve(is_available);
  });

  promise.then(function(value) {
    value.val()
    if( value.val() != "true" || value.length == 0 ){
      $('.is_th').remove();
    }
  $('#aircraftDTIndex').DataTable();

  }, function(reason) {
    console.log(reason); // Error!
  });

});
