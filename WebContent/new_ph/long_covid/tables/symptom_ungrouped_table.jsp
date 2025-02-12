<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<script>

function ${param.block}_constrain_table(filter, constraint) {
	var table = $('#${param.target_div}-table').DataTable();
	// console.log("${param.block}", filter, constraint)
	switch (filter) {
	case 'covidstatus':
		table.column(0).search(constraint, true, false, true).draw();	
		break;
	case 'longstatus':
		table.column(1).search(constraint, true, false, true).draw();	
		break;
	case 'age':
		table.column(2).search(constraint, true, false, true).draw();	
		break;
	case 'sex':
		table.column(3).search(constraint, true, false, true).draw();	
		break;
	case 'race':
		table.column(4).search(constraint, true, false, true).draw();	
		break;
	case 'ethnicity':
		table.column(5).search(constraint, true, false, true).draw();	
		break;
	case 'symptom':
		table.column(6).search(constraint, true, false, true).draw();	
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
		
		if (column == 'covid_patient_count'){
			if (data['status'] == 'Positive'){
				sum += data['patient_count'];
			};
		};
		
		if (column == 'long_patient_count'){
			if (data['long'] == 'Long COVID'){
				sum += data['patient_count'];
			};
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

	${param.block}_datatable = $('#${param.target_div}-table').DataTable( {
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
    	      exportOptions: {
                  columns: ':visible'
              },
    	      titleAttr: 'CSV export.',
    	      text: 'CSV',
    	      filename: 'symptom_ungrouped_csv_export',
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
       	 	setTimeout(function() {jQuery('.loading').fadeOut(100); ${param.block}_refreshHistograms(); }, 500);
       	},
    	pageLength: 10,
    	lengthMenu: [ 10, 25, 50, 75, 100 ],
    	order: [[0, 'asc']],
     	columns: [
     		{ data: 'status', visible: true, orderable: true },
        	{ data: 'long', visible: true, orderable: true },
        	{ data: 'age', visible: true, orderable: true, orderData: [10] },
        	{ data: 'sex', visible: true, orderable: true },
        	{ data: 'race', visible: true, orderable: true },
        	{ data: 'ethnicity', visible: true, orderable: true },
        	{ data: 'symptom', visible: true, orderable: true },
        	{ data: 'patient_display', visible: true, orderable: true, orderData: [8] },
        	{ data: 'patient_count', visible: false },
        	{ data: 'age_abbrev', visible: false },
        	{ data: 'age_seq', visible: false },
        	{ data: 'race_abbrev', visible: false },
        	{ data: 'race_seq', visible: false },
        	{ data: 'ethnicity_abbrev', visible: false },
        	{ data: 'ethnicity_seq', visible: false },
        	{ data: 'sex_abbrev', visible: false },
        	{ data: 'sex_seq', visible: false },
        	{ data: 'symptom_seq', visible: false },
        	{ data: 'status_abbrev', visible: false },
        	{ data: 'status_seq', visible: false },
        	{ data: 'long_abbrev', visible: false },
        	{ data: 'long_seq', visible: false }
    	]
	} );

	// table search logic that distinguishes sort/filter 
	${param.block}_datatable.on( 'search.dt', function () {
		var snapshot = ${param.block}_datatable
	     .rows({ search: 'applied', order: 'index'})
	     .data()
	     .toArray()
	     .toString();

	  	var currentSnapshot = ${param.block}_datatable.settings().init().snapshot;

	  	if (currentSnapshot != snapshot) {
	  		${param.block}_datatable.settings().init().snapshot = snapshot;
	  		${param.block}_refreshHistograms();
			${param.block}_constrain_table();
	   		$('#${param.block}_btn_clear').removeClass("no_clear");
	   		$('#${param.block}_btn_clear').addClass("show_clear");
	  	}
	} );

	

	
});

</script>
