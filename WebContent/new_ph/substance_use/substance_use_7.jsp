<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<jsp:include page="../block3.jsp">
	<jsp:param name="block" value="substance_use_7" />
	<jsp:param name="block_header" value="Substance Use: Demographics" />
	<jsp:param name="folder" value="substance_use" />
	<jsp:param name="topic_description" value="secondary_7" />
	<jsp:param name="did" value="${param.did}" />
	<jsp:param name="topic_title" value="Patients using Substances" />

	<jsp:param name="kpis" value="substance_use/kpis.jsp" />
	
	<jsp:param name="age_filter_ideal" value="true" />
	<jsp:param name="race_filter" value="true" />
	<jsp:param name="sex_filter" value="true" />
	<jsp:param name="ethnicity_filter" value="true" />
	<jsp:param name="alcohol_status_filter" value="true" />
	<jsp:param name="smoking_status_filter" value="true" />
	<jsp:param name="opioids_status_filter" value="true" />
	<jsp:param name="cannabis_status_filter" value="true" />
	<jsp:param name="covid_filter" value="true" />
	
	<jsp:param name="toggle" value="true" />
	
	<jsp:param name="viz_properties" value="{'age' : [{
			dimension: 'age',
			domName: '#substance_use_7_age_viz',
			barLabelWidth: 100,
			min_height: 300,
			ordered: 0,
			colorscale: age_range_all,
			legend_label: 'Age',
			legend_data: age_legend_ideal,
			donutRatio: 0.5
		}], 'race' : [{
			dimension: 'race',
			domName: '#substance_use_7_race_viz',
			barLabelWidth: 100,
			min_height: 300,
			ordered: 0,
			colorscale: race_range,
			legend_label: 'Race',
			legend_data: race_legend,
			donutRatio: 0.5
		}], 'sex' : [{
			dimension: 'sex',
			domName: '#substance_use_7_sex_viz',
			barLabelWidth: 100,
			min_height: 300,
			ordered: 0,
			colorscale: sex_range,
			legend_label: 'Sex',
			legend_data: sex_legend,
			donutRatio: 0.5
		}], 'ethnicity' : [{
			dimension: 'ethnicity',
			domName: '#substance_use_7_ethnicity_viz',
			barLabelWidth: 100,
			min_height: 300,
			ordered: 0,
			colorscale: ethnicity_range,
			legend_label: 'Ethnicity',
			legend_data: ethnicity_legend,
			donutRatio: 0.5
		}], 'alcohol_status' : [{
			dimension: 'alcohol',
			domName: '#substance_use_7_alcoholstatus_viz',
			barLabelWidth: 100,
			min_height: 300,
			ordered: 0,
			colorscale: alcohol_status_range,
			legend_label: 'AlcoholStatus',
			legend_data: alcohol_status_legend,
			donutRatio: 0.5
		}], 'smoking_status' : [{
			dimension: 'smoking',
			domName: '#substance_use_7_smokingstatus_viz',
			barLabelWidth: 100,
			min_height: 300,
			ordered: 0,
			colorscale: smoking_status_range,
			legend_label: 'SmokingStatus',
			legend_data: smoking_status_legend,
			donutRatio: 0.5
		}], 'opioids_status' : [{
			dimension: 'opioids',
			domName: '#substance_use_7_opioidsstatus_viz',
			barLabelWidth: 100,
			min_height: 300,
			ordered: 0,
			colorscale: opioids_status_range,
			legend_label: 'OpioidsStatus',
			legend_data: opioids_status_legend,
			donutRatio: 0.5
		}], 'cannabis_status' : [{
			dimension: 'cannabis',
			domName: '#substance_use_7_cannabisstatus_viz',
			barLabelWidth: 100,
			min_height: 300,
			ordered: 0,
			colorscale: cannabis_status_range,
			legend_label: 'CannabisStatus',
			legend_data: cannabis_status_legend,
			donutRatio: 0.5
		}], 'covid_status' : [{
			dimension: 'covid',
			domName: '#substance_use_7_covidstatus_viz',
			barLabelWidth: 100,
			min_height: 300,
			ordered: 0,
			colorscale: covidstatus_range,
			legend_label: 'Covidstatus',
			legend_data: covidstatus_legend,
			donutRatio: 0.5
		}]
	}"/>
	
	<jsp:param name="age_panel" value="substance_use/age.jsp" />
	<jsp:param name="race_panel" value="substance_use/race.jsp" />
	<jsp:param name="sex_panel" value="substance_use/sex.jsp" />
	<jsp:param name="ethnicity_panel" value="substance_use/ethnicity.jsp" />
	<jsp:param name="alcohol_status_panel" value="substance_use/alcohol_status.jsp" />
	<jsp:param name="cannabis_status_panel" value="substance_use/cannabis_status.jsp" />
	<jsp:param name="covidstatus_panel" value="substance_use/covid_status.jsp" />
	<jsp:param name="opioids_status_panel" value="substance_use/opioids_status.jsp" />
	<jsp:param name="smoking_status_panel" value="substance_use/smoking_status.jsp" />

	<jsp:param name="datatable" value="substance_use/tables/all_demographics.jsp" />
	<jsp:param name="datatable_div" value="substance_all_demo" />
	<jsp:param name="datatable_feed" value="substance_use/feeds/all_demographics.jsp" />
	<jsp:param name="datatable_kpis" value="patient_count" />
	
	<jsp:param name="AgeArray" value="true" />
	<jsp:param name="RaceArray" value="true" />
	<jsp:param name="SexArray" value="true" />
	<jsp:param name="EthnicityArray" value="true" />
	<jsp:param name="AlcoholStatusArray" value="true" />
	<jsp:param name="CannabisStatusArray" value="true" />
	<jsp:param name="CovidstatusArray" value="true" />
	<jsp:param name="OpioidsStatusArray" value="true" />
	<jsp:param name="SmokingStatusArray" value="true" />

</jsp:include>

<script>
	var panels = ["age", "race", "sex", "ethnicity", "alcohol_status", "smoking_status", "opioids_status", "cannabis_status", "covidstatus"];
	substance_use_7_panel(panels);
</script>
