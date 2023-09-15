<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<script>


// kpi updates ///////////////////////////////
function ${param.block}_constrain_table(filter, constraint) {
	var table = $('#${param.target_div}-table').DataTable();
console.log(filter,constraint)
	switch (filter) {
	case 'age':
		table.column(0).search(constraint, true, false, true).draw();	
		break;
	case 'race':
		table.column(1).search(constraint, true, false, true).draw();	
		break;
	case 'sex':
		table.column(2).search(constraint, true, false, true).draw();	
		break;
	case 'ethnicity':
		table.column(3).search(constraint, true, false, true).draw();	
		break;
	case 'alcoholstatus':
		table.column(4).search(constraint, true, false, true).draw();	
		break;
	case 'smokingstatus':
		table.column(5).search(constraint, true, false, true).draw();	
		break;
	case 'opioidsstatus':
		table.column(6).search(constraint, true, false, true).draw();	
		break;
	case 'cannabisstatus':
		table.column(7).search(constraint, true, false, true).draw();	
		break;
	case 'covidstatus':
		table.column(8).search(constraint, true, false, true).draw();	
		break;
	}
	
	
	var kpis = '${param.target_kpis}'.split(',');
	for (var a in kpis) {
		${param.block}_updateKPI(table, kpis[a])
	}
}

function ${param.block}_updateKPI(table, column) {
	var sum_string = '';
	var sum = 0;
	
	
	table.rows({ search:'applied' }).every( function ( rowIdx, tableLoop, rowLoop ) {
		var data = this.data();
		if (column == 'patient_count'){
			sum += data['patient_count'];
		};
	});	
	
	

	if (sum < 1000) {
		sumString = sum+'';
	} else if (sum < 1000000) {
		sum = sum / 1000.0;
		sumString = sum.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2}) + "k";
	} else {
		sum = sum / 1000000.0;
		sumString = sum.toLocaleString('en-US', {minimumFractionDigits: 2, maximumFractionDigits: 2}) + "M";
		
	}
	console.log(column,sumString)
	document.getElementById('${param.block}'+'_'+column+'_kpi').innerHTML = sumString;
}

jQuery.fn.dataTable.Api.register( 'sum()', function ( ) {
	return this.flatten().reduce( function ( a, b ) {
		if ( typeof a === 'string' ) {
			a = a.replace(/[^\d.-]/g, '') * 1;
		}
		if ( typeof b === 'string' ) {
			b = b.replace(/[^\d.-]/g, '') * 1;
		}

		return a + b;
	}, 0 );
} );

var ${param.block}_datatable = null;


// datatable setup ////////////////////////
$.getJSON("<util:applicationRoot/>/new_ph/${param.feed}", function(data){
		
	var json = $.parseJSON(JSON.stringify(data));

	var col = [];

	for (i in json['headers']){
		col.push(json['headers'][i]['label']);
	}


	var table = document.createElement("table");
	table.className = 'table table-hover compact site-wrapper';
	table.style.width = '100%';
	table.id="${param.target_div}-table";

	var header= table.createTHead();
	var header_row = header.insertRow(0); 

	for (i in col) {
		var th = document.createElement("th");
		th.innerHTML = '<span style="color:#333; font-weight:600; font-size:14px;">' + col[i].toString() + '</span>';
		header_row.appendChild(th);
	}

	var divContainer = document.getElementById("${param.target_div}");
	divContainer.appendChild(table);

	var data = json['rows'];

	var ${param.block}_datatable = $('#${param.target_div}-table').DataTable( {
	    data: data,
    	dom: 'lfr<"datatable_overflow"t>Bip',
    	buttons: {
    	    dom: {
    	      button: {
    	        tag: 'button',
    	        className: ''
    	      }
    	    },
    	    buttons: [{
    	      extend: 'csv',
    	      className: 'btn btn-sm btn-light',
    	      titleAttr: 'CSV export.',
    	      exportOptions: {
                  columns: ':visible'
              },
    	      text: 'CSV',
    	      filename: 'metformin_demographics',
    	      extension: '.csv'
    	    }, {
    	      extend: 'copy',
    	      className: 'btn btn-sm btn-light',
    	      exportOptions: {
                  columns: ':visible'
              },
    	      titleAttr: 'Copy table data.',
    	      text: 'Copy'
    	    }]
    	},
       	paging: true,
       	snapshot: null,
       	initComplete: function( settings, json ) {
       	 	settings.oInit.snapshot = $('#${param.target_div}-table').DataTable().rows({order: 'index'}).data().toArray().toString();
       	 	settings.oInit.snapshotAll = $('#${param.target_div}-table').DataTable().rows({order: 'index'}).data().toArray().toString();
       	},
    	pageLength: 10,
    	lengthMenu: [ 10, 25, 50, 75, 100 ],
    	order: [[0, 'asc']],
     	columns: [
        	{ data: 'age', visible: true, orderable: true, orderData: [12] },
        	{ data: 'race', visible: true, orderable: true },
        	{ data: 'sex', visible: true, orderable: true },
        	{ data: 'ethnicity', visible: true, orderable: true },
        	{ data: 'alcohol', visible: true, orderable: true },
        	{ data: 'smoking', visible: true, orderable: true },
        	{ data: 'opioids', visible: true, orderable: true },
        	{ data: 'cannabis', visible: true, orderable: true },
        	{ data: 'status', visible: true, orderable: true },
        	{ data: 'patient_display', visible: true, orderable: true, orderData: [10] },
        	{ data: 'patient_count', visible: false },
        	{ data: 'age_abbrev', visible: false },
        	{ data: 'age_seq', visible: false },
        	{ data: 'race_abbrev', visible: false },
        	{ data: 'race_seq', visible: false },
        	{ data: 'sex_abbrev', visible: false },
        	{ data: 'sex_seq', visible: false },
        	{ data: 'ethnicity_abbrev', visible: false },
        	{ data: 'ethnicity_seq', visible: false },
        	{ data: 'alcohol_abbrev', visible: false },
        	{ data: 'alcohol_seq', visible: false },
        	{ data: 'smoking_abbrev', visible: false },
        	{ data: 'smoking_seq', visible: false },
        	{ data: 'opioids_abbrev', visible: false },
        	{ data: 'opioids_seq', visible: false },
        	{ data: 'cannabis_abbrev', visible: false },
        	{ data: 'cannabis_seq', visible: false },
        	{ data: 'status_abbrev', visible: false },
        	{ data: 'status_seq', visible: false }
        	
    	]
	} );
	
	${param.block}_refreshHistograms();
});





</script>