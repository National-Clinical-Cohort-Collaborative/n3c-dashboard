<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<jsp:include page="../block3.jsp">
	<jsp:param name="block" value="long_covid_2" />
	<jsp:param name="block_header" value="Long COVID: Clinic Visit" />
	<jsp:param name="topic_description" value="secondary_2" />
	<jsp:param name="topic_title" value="Patients Who Have Visited a Long COVID Clinic" />
	<jsp:param name="folder" value="long_covid" />
	<jsp:param name="did" value="${param.did}" />

	<jsp:param name="kpis" value="long_covid/kpis.jsp" />

	<jsp:param name="race_filter" value="true" />
	<jsp:param name="sex_filter" value="true" />
	<jsp:param name="age_filter_min" value="true" />
	<jsp:param name="only_demo" value="true" />
	
	<jsp:param name="toggle" value="true" />
	<jsp:param name="viz_properties" value="{'age' : [{
			dimension: 'age',
			domName: '#long_covid_2_age_viz',
			barLabelWidth: 125,
			min_height: 300,
			ordered: 0,
			colorscale: age_range_min,
			legend_label: 'Age',
			legend_data: age_legend_min,
			donutRatio: 0.5
		}], 'race' : [{
			dimension: 'race',
			domName: '#long_covid_2_race_viz',
			barLabelWidth: 125,
			min_height: 300,
			ordered: 0,
			colorscale: race_range,
			legend_label: 'Race',
			legend_data: race_legend,
			donutRatio: 0.5
		}], 'sex' : [{
			dimension: 'sex',
			domName: '#long_covid_2_sex_viz',
			barLabelWidth: 125,
			min_height: 300,
			ordered: 0,
			colorscale: sex_range,
			legend_label: 'Sex',
			legend_data: sex_legend,
			donutRatio: 0.5
		}]
	}"/>
	
	<jsp:param name="age_panel" value="long_covid/age.jsp" />
	<jsp:param name="race_panel" value="long_covid/race.jsp" />
	<jsp:param name="sex_panel" value="long_covid/sex.jsp" />

	<jsp:param name="datatable" value="long_covid/tables/clinicvisit_table.jsp" />
	<jsp:param name="datatable_div" value="long_covid_clinic" />
	<jsp:param name="datatable_feed" value="long_covid/feeds/clinicvisit.jsp" />
	<jsp:param name="datatable_kpis" value="patient_count" />
	
	<jsp:param name="AgeArray" value="true" />
	<jsp:param name="RaceArray" value="true" />
	<jsp:param name="SexArray" value="true" />
</jsp:include>

<script>
	var panels = ["age", "race", "sex"];
	long_covid_2_panel(panels);
</script>