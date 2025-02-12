<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<div class="row">
	<div class="col-12 viz-header-section">
		<div style="display:flex; flex-wrap: nowrap;">
			<h2 id="${param.block}age-title" class="viz-title"></h2>
			<div>
				<button type="button" class="btn btn-sm btn-light dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
					<i class="fas fa-download"></i>
				</button>
				<div class="dropdown-menu dropdown-menu-right">
					<a class="dropdown-item" onclick="save_viz_pass_age('.jpg');">Save as JPG</a>
					<a class="dropdown-item" onclick="save_viz_pass_age('.png');">Save as PNG</a>
					<a class="dropdown-item" onclick="save_viz_pass_age('.svg');">Save as SVG</a>
				</div>
			</div>
		</div>
	</div>
	<div class="col-12"> 
		<div id="${param.block}_age_legend"></div>
	</div>
	<div class="col-12">
		<div class="loading">
			<img src="<util:applicationRoot/>/images/loader.gif" alt="load">
		</div>
		<div id="${param.block}_age_viz" class="dash_viz clip">
		</div>
	</div>
</div>

<script>

//this is to change the title of the download based on which visualization mode is selected
function save_viz_pass_age(extension){
	var text = text = "${param.topic_title} ${param.topic_disease} by Observation Type and Age" + extension;
	saveVisualization('${param.block}_age_viz', text);
};


var title = "${param.topic_title} ${param.topic_disease} by Observation Type and Age";
$("#${param.block}age-title").text(title);


function ${param.block}_age_refresh() {
	var properties = {
			domName: '${param.block}_age_viz',
			block: '${param.block}',
			primary: 'observation',
			secondary: 'age',
			count: 'patient_count',
			xaxis_label: 'Count',
			xaxis_label2: 'Percent',
			legend_label: age_legend_min,
			colorscale: age_range_min,
			label1: 'Observation',
			label2: 'Age',
			offset: 210,
			array: 'status',
			observationtotal: true,
			legendid: "${param.block}_age_legend"
	};
	
	d3.select("#${param.block}_age_viz").select("svg").remove();
	
	localHorizontalGroupedBarChart_new(${param.block}_statusArray, properties);	
}

</script>
