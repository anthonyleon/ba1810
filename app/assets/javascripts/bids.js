$(document).on('ready page: load', function() {
    $('table tbody tr').click(function(){
        alert($(this).text());
    });
});
