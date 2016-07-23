$(function() {
  var promise2 = new Promise(function(resolve,reject){
    var is_available = $('#is_available_engine');
    resolve(is_available);
  });
  promise2
  .then(function(value){
    console.log("ENGINE",value.val());
    if (value.val() == "true") {
      $('#engineDT').DataTable();
    }

    if(value.val() != true || value.length == 0) {
      $('.is_h').remove();
      console.log("AWESOME", value.val(), value.length);
    }
    $('#engineDT').DataTable();
  }, function(error){
    console.log(error);
  });

// $('#engineDT').DataTable();
});
