<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>


<div id="${param.block}_sex_viz" class="col-12 dash_viz"></div>

<c:if test="${not empty param.symptom}">
<div id="${param.block}-long-sex">
	<jsp:include page="../long_covid/long_before_static.jsp">
		<jsp:param name="block" value="${param.block}" />
		<jsp:param name="type" value="sex" />
		<jsp:param name="symptom" value="${param.symptom}" />
	</jsp:include>
</div>
</c:if>

<c:if test="${not empty param.topic_description}">
	<div id="viz_caption">
		<jsp:include page="../long_covid/secondary_text/${param.topic_description}.jsp"/>
	</div>
</c:if>

<div id="${param.block}_sex_save_viz"> 
	<button id='svgButton' class="btn btn-light btn-sm" onclick="saveVisualization('${param.block}_sex_viz', '${param.block}_sex.svg');">Save as SVG</button>
	<button id='pngButton' class="btn btn-light btn-sm" onclick="saveVisualization('${param.block}_sex_viz', '${param.block}_sex.png');">Save as PNG</button>
	<button id='jpegButton' class="btn btn-light btn-sm" onclick="saveVisualization('${param.block}_sex_viz', '${param.block}_sex.jpg');">Save as JPEG</button>
	<br><small>Note: Download will only include the top graph.</small>
</div>


<script>

var labeltest = '${param.label_width}';
var labelWidth = 150;

if (labeltest.length != 0){
	labelWidth = Number('${param.label_width}');
};

function ${param.block}_sex_refresh() {
	var properties = {
			domName: '${param.block}_sex_viz',
			barLabelWidth: labelWidth,
			legend_data: sex_legend,
			secondary_range: sex_range,
			legend_label: 'Sex',
			min_height: 200,
			nofilter: 0,
			ordered: 1
		}

	// console.log("sex graph", "${param.block}_sex_viz", ${param.block}_ObservationSexArray)
   	d3.select("#${param.block}_sex_viz").select("svg").remove();
	localHorizontalStackedBarChart(${param.block}_ObservationSexArray, properties);	
}

${param.block}_sex_refresh();
</script>