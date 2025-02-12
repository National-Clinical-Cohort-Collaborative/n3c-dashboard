<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<jsp:include page="../block3.jsp">
	<jsp:param name="block" value="pprl_9" />
	<jsp:param name="block_header" value="COVID Factors of Patients Linked to Mortality Data" />
	<jsp:param name="folder" value="pprl" />
	<jsp:param name="topic_description" value="secondary_9" />
	<jsp:param name="did" value="${param.did}" />
	<jsp:param name="topic_title" value="COVID+ Patients in the Enclave linked to Mortality Data" />

	<jsp:param name="kpis" value="pprl/kpis.jsp" />
	
	<jsp:param name="severity_filter" value="true" />
	<jsp:param name="long_filter" value="true" />
	<jsp:param name="race_filter" value="true" />
	<jsp:param name="vaccinated_filter" value="true" />
	
	<jsp:param name="toggle" value="true" />
	
	<jsp:param name="viz_properties" value="{'severity' : [{
			dimension: 'severity',
			domName: '#pprl_9_severity_viz',
			barLabelWidth: 100,
			min_height: 300,
			ordered: 0,
			colorscale: severity_range,
			legend_label: 'Severity',
			legend_data: severity_legend,
			donutRatio: 0.5
		}], 'vaccinationstatus' : [{
			dimension: 'vaccinationstatus',
			domName: '#pprl_9_vaccinationstatus_viz',
			barLabelWidth: 100,
			min_height: 300,
			ordered: 0,
			colorscale: vaccinated_range,
			legend_label: 'Vaccinationstatus',
			legend_data: vaccinated_legend,
			donutRatio: 0.5
		}], 'longstatus' : [{
			dimension: 'longstatus',
			domName: '#pprl_9_longstatus_viz',
			barLabelWidth: 100,
			min_height: 300,
			ordered: 0,
			colorscale: longstatus_range,
			legend_label: 'Longstatus',
			legend_data: longstatus_legend,
			donutRatio: 0.5
		}], 'race' : [{
			dimension: 'race',
			domName: '#pprl_9_race_viz',
			barLabelWidth: 100,
			min_height: 300,
			ordered: 0,
			colorscale: race_range,
			legend_label: 'Race',
			legend_data: race_legend,
			donutRatio: 0.5
		}]
	}"/>
	
	<jsp:param name="vaccinationstatus_panel" value="pprl/vaccinated.jsp"/>
	<jsp:param name="longstatus_panel" value="pprl/longstatus.jsp"/>
	<jsp:param name="race_panel" value="pprl/race.jsp"/>
	<jsp:param name="mortality_panel" value="pprl/mortality.jsp"/>
	<jsp:param name="severity_panel" value="pprl/severity.jsp"/>


	<jsp:param name="datatable" value="pprl/tables/mort_covid_table.jsp"/>
	<jsp:param name="datatable_div" value="pprl_pprl_9"/>
	<jsp:param name="datatable_feed" value="pprl/feeds/mort_covid.jsp"/>
	<jsp:param name="datatable_kpis" value="patient_count"/>
	
	<jsp:param name="SeverityArray" value="true" />
	<jsp:param name="VaccinationstatusArray" value="true" />
	<jsp:param name="LongstatusArray" value="true" />
	<jsp:param name="RaceArray" value="true" />

</jsp:include>

<script>
	var panels = ["severity", "vaccinationstatus", "longstatus", "race"];
	pprl_9_panel(panels);
</script>
