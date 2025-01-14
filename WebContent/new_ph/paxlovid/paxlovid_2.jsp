<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<style>
	.paxlovid .dataTables_filter{
		display: unset;
	}
</style>

<div class="paxlovid_1">
	
	<jsp:include page="kpis.jsp">
		<jsp:param value="paxlovid_1" name="block"/>
	</jsp:include>

	<div class="row">
		<div class="col-12 mx-auto mt-2 mb-2 text-center">
			<h4>Top 20 Most Frequent Medications Seen Between 6 to 27 Days After Paxlovid Treatment</h4>
		</div>
		<div class="col-12 col-md-6 viz" id="drugs_viz_1">
			<div id="drugs_viz"></div>
			<jsp:include page="vizs/stacked_bar.jsp">
				<jsp:param name="domName" value='drugs_viz' />
 				<jsp:param name="feed" value="topten_drugs.jsp" />
				<jsp:param name="primary" value="medication" />
				<jsp:param name="secondary" value="result" />
				<jsp:param name="textmargin" value="260" />
			</jsp:include>
		</div>
		<div class="col-12 col-md-6 viz-table" id="drugs_table_1">
			<jsp:include page="tables/top10_drugs_table.jsp" flush="true"/>
		</div>
	</div>
	<div class="row">
		<div class="col-12 mx-auto mt-2 mb-2 text-center">
			<h4>All Medications Seen Between 6 to 27 Days After Paxlovid Treatment </h4>
		</div>
		<div class="col-12 col-md-6 viz-table" id="drugs_table_2">
			<h5 class="text-center">Total Occurrences Greater Than 20</h5>
			<jsp:include page="tables/greater_drugs_table.jsp" flush="true"/>
		</div>
		<div class="col-12 col-md-6 viz-table" id="drugs_table_3">
			<h5 class="text-center">Total Occurrences Less Than 20</h5>
			<jsp:include page="tables/less20_drugs_table.jsp" flush="true"/>
		</div>
	</div>
</div>

<script>
$('#drugs_viz-testresult-select').multiselect({	
	onChange: function(option, checked, select) {
		var options = $('#drugs_viz-testresult-select');
        var selected = [];
        $(options).each(function(){
            selected.push($(this).val());
        });
		${param.block}_constrain("result",  selected[0].join('|'));
    }
});
</script>
	