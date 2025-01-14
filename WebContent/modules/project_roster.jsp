<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<style>
.project-panel-group .title{
	font-size: 1.3rem;
	line-height: 1;
	font-weight: 400;
	color: #222;
}
</style>

<script>
$.getJSON("<util:applicationRoot/>/feeds/project_roster.jsp", function(data){
		
	var json = $.parseJSON(JSON.stringify(data));

	var col = [];

	for (i in json['headers']){
		col.push(json['headers'][i]['label']);
	}


	var table = document.createElement("table");
	table.className = 'table table-hover table-expand';
	table.style.width = '100%';
	table.style.textAlign = "left";
	table.id="project-table";

	var header= table.createTHead();
	var header_row = header.insertRow(0); 

	for (i in col) {
		var th = document.createElement("th");
		th.innerHTML = '<span style="color:#333; font-weight:500; font-size:1.5rem;">' + col[i].toString() + '</span>';
		header_row.appendChild(th);
	}

	var divContainer = document.getElementById("project-roster");
	divContainer.innerHTML = "";
	divContainer.appendChild(table);

	var data = json['rows'];

	$('#project-table').DataTable( {
    	data: data,
       	paging: true,
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
    	    	  columns: ':not(.noExport)'
              },
    	      text: 'CSV',
    	      filename: 'N3C_projects_csv_export',
    	      extension: '.csv'
    	    }, {
    	      extend: 'copy',
    	      className: 'btn btn-sm btn-light',
    	      exportOptions: {
    	    	  columns: ':not(.noExport)'
              },
    	      titleAttr: 'Copy table data.',
    	      text: 'Copy'
    	    }]
    	},
       	language: {
            searchPlaceholder: "title, researcher, institution ..."
        },
       	drawCallback: function( settings ) {$("#project-table thead").remove(); } ,
    	pageLength: 5,
    	lengthMenu: [ 5, 10, 25, 50, 75, 100 ],
    	order: [[0, 'asc']],
    	columns: [
        	{   data: 'task_team',
        		orderable: false,
        		className: 'noExport',
        		render: function ( data, type, row ) {
        			var title = row.title;
        			var id = row.id;
        			var desc = row.description;
        			var contact = row.pi_name;
        			var institution = row.accessing_institution;
        			var dur = row.dur_project_id;
        			var combo = 
        				'<div class="project-panel-group panel-group" style="margin-bottom:0px;" id="' 
        				+ id.replace(/\s+/g, '').toLowerCase() + '_accordion' +
        				'"><div class="panel panel-default" style="background:none; border:none; box-shadow:none;"><div class="panel-heading" style="background:none; text-align:left;"><div class="row" style="margin-right:0px;"><div class="col-11"><p class="mb-0 title">'
        				+ title + 
        				' </p></div> <div class="col-1" style="margin: auto;"> <p class="mb-0" style="text-align: right; font-size:16px;"><a aria-expanded="false" class="accordion-toggle" data-toggle="collapse" data-parent="#'
        				+ id.replace(/\s+/g, '').toLowerCase() + '_accordion' + 
        				'" href="#'
        				+ id.replace(/\s+/g, '').toLowerCase() + '_description' +
        				'"> </a></p></div></div> </div><div id="'
        				+ id.replace(/\s+/g, '').toLowerCase() + '_description' +
        				'" class="panel-collapse collapse"><div class="panel-body" style="border:none;">'
        				+ desc + '<\/p>' + '<strong>Lead Investigator: ' + contact + '<\/strong> <br> <strong>Accessing Institution: ' + institution + '<\/strong> <br> ID: ' + id + ' (' + dur + ')'
        				+ '</div></div></div></div>';
             		return combo; }
             },
            { data: 'title', visible: false },
        	{ data: 'description', visible: false },
        	{ data: 'pi_name', visible: false },
        	{ data: 'accessing_institution', visible: false},
        	{ data: 'id', visible: false},
        	{ data: 'dur_project_id', visible: false}
    	]
	} );

	
});
</script>