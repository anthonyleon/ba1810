$(function() {

  var promiseEngine = new Promise(function(resolve,reject){
    var is_available = $('#is_available_engine');
    resolve(is_available);
  });
  promiseEngine
  .then(function(value){
    if (value.val() === 'true') {
        console.log("HERE");
      $('#engineDT').DataTable({
        "columnDefs": [{ "width": "60px", "targets": 9 }]
      });
    }

    if(value.val() != true || value.length == 0) {
      $('.is_h').remove();
    }
    // $('#engineDT').DataTable({
    //   "columnDefs": [{ "width": "120px", "targets": 9 }]
    // });
  }, function(error){
    console.log(error);
  });

// $('#engineDT').DataTable();
});
