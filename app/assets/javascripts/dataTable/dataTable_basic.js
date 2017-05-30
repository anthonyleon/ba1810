/* ------------------------------------------------------------------------------
*
*  # Basic datatables
*
*  Specific JS code additions for datatable_basic.html page
*
*  Version: 1.0
*  Latest update: Aug 1, 2015
*
* ---------------------------------------------------------------------------- */

$(function() {


    // Table setup
    // ------------------------------

    // Setting datatable defaults
    $.extend( $.fn.dataTable.defaults, {
        autoWidth: false,
        dom: '<"datatable-header"fl><"datatable-scroll"t><"datatable-footer"ip>',
        language: {
            search: '<span>Filter:</span> _INPUT_',
            searchPlaceholder: 'Type to filter...',
            lengthMenu: '<span>Show:</span> _MENU_',
            paginate: { 'first': 'First', 'last': 'Last', 'next': '&rarr;', 'previous': '&larr;' }
        },
        drawCallback: function () {
            $(this).find('tbody tr').slice(-3).find('.dropdown, .btn-group').addClass('dropup');
        },
        preDrawCallback: function() {
            $(this).find('tbody tr').slice(-3).find('.dropdown, .btn-group').removeClass('dropup');
        }
    });
function naturalSort (a, b, html) {
    var re = /(^-?[0-9]+(\.?[0-9]*)[df]?e?[0-9]?%?$|^0x[0-9a-f]+$|[0-9]+)/gi,
        sre = /(^[ ]*|[ ]*$)/g,
        dre = /(^([\w ]+,?[\w ]+)?[\w ]+,?[\w ]+\d+:\d+(:\d+)?[\w ]?|^\d{1,4}[\/\-]\d{1,4}[\/\-]\d{1,4}|^\w+, \w+ \d+, \d{4})/,
        hre = /^0x[0-9a-f]+$/i,
        ore = /^0/,
        htmre = /(<([^>]+)>)/ig,
        // convert all to strings and trim()
        x = a.toString().replace(sre, '') || '',
        y = b.toString().replace(sre, '') || '';
        // remove html from strings if desired
        if (!html) {
            x = x.replace(htmre, '');
            y = y.replace(htmre, '');
        }
        // chunk/tokenize
    var xN = x.replace(re, '\0$1\0').replace(/\0$/,'').replace(/^\0/,'').split('\0'),
        yN = y.replace(re, '\0$1\0').replace(/\0$/,'').replace(/^\0/,'').split('\0'),
        // numeric, hex or date detection
        xD = parseInt(x.match(hre), 10) || (xN.length !== 1 && x.match(dre) && Date.parse(x)),
        yD = parseInt(y.match(hre), 10) || xD && y.match(dre) && Date.parse(y) || null;
 
    // first try and sort Hex codes or Dates
    if (yD) {
        if ( xD < yD ) {
            return -1;
        }
        else if ( xD > yD ) {
            return 1;
        }
    }
 
    // natural sorting through split numeric strings and default strings
    for(var cLoc=0, numS=Math.max(xN.length, yN.length); cLoc < numS; cLoc++) {
        // find floats not starting with '0', string or 0 if not defined (Clint Priest)
        var oFxNcL = !(xN[cLoc] || '').match(ore) && parseFloat(xN[cLoc], 10) || xN[cLoc] || 0;
        var oFyNcL = !(yN[cLoc] || '').match(ore) && parseFloat(yN[cLoc], 10) || yN[cLoc] || 0;
        // handle numeric vs string comparison - number < string - (Kyle Adams)
        if (isNaN(oFxNcL) !== isNaN(oFyNcL)) {
            return (isNaN(oFxNcL)) ? 1 : -1;
        }
        // rely on string comparison if different types - i.e. '02' < 2 != '02' < '2'
        else if (typeof oFxNcL !== typeof oFyNcL) {
            oFxNcL += '';
            oFyNcL += '';
        }
        if (oFxNcL < oFyNcL) {
            return -1;
        }
        if (oFxNcL > oFyNcL) {
            return 1;
        }
    }
    return 0;
}
 


    $('#inventoryPartsDT').dataTable({
      "processing": true,
      "serverSide": true,
      "ajax": $('#inventoryPartsDT').data('source'),
      "pageLength": 25,
      "aoColumns": [
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
        { "bSortable": false },
        { "bSortable": true },
        { "bSortable": false }
      ]
    });

    $('#buyerAuctionsDT').DataTable({
      columnDefs: [{
        orderable: false,
        targets: [7]
      }]
    });
    // Basic datatable
    // $('.datatable-basic').DataTable({
    //     columnDefs: [{
    //         orderable: false,
    //         width: '100px',
    //         targets: [ 7 ]
    //     }],
    //     stateSave: true
    // });

    $('#purchasesDT').DataTable({
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



    $('#pendingSalesDT').dataTable({
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

    $('#salesDT').dataTable({
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

    $('#aircraftDT').DataTable({
      "aoColumns": [
        { "bSortable": true },
        { "bSortable": true },
        { "bSortable": true },
        { "bSortable": true },
        { "bSortable": true },
        { "bSortable": true },
        { "bSortable": true },
        { "bSortable": true},
        { "bSortable": true},
        { "bSortable": false}
      ]
    })
    // Alternative pagination
    $('.datatable-pagination').DataTable({
        pagingType: "simple",
        language: {
            paginate: {'next': 'Next &rarr;', 'previous': '&larr; Prev'}
        }
    });


    // Datatable with saving state
    $('.datatable-save-state').DataTable({
        stateSave: true
    });


    // Scrollable datatable
    $('.datatable-scroll-y').DataTable({
        autoWidth: true,
        scrollY: 300
    });



    // External table additions
    // ------------------------------

    // Enable Select2 select for the length option
    $('.dataTables_length select').select2({
        minimumResultsForSearch: Infinity,
        width: 'auto'
    });

});
