<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<!-- positive_cases_by_day_cumsum_censored (2022-03-31 05:01) -->

<jsp:include page="../block3.jsp">
	<jsp:param name="block" value="reinfection_ts_1" />
	<jsp:param name="block_header" value="Reinfection Time Series" />
	<jsp:param name="topic_description" value="secondary_1" />
	<jsp:param name="folder" value="reinfection_time_series" />

	<jsp:param name="kpis" value="reinfection_time_series/kpis.jsp" />

	<jsp:param name="did" value="${param.did}" />
	
	<jsp:param name="simple_panel" value="reinfection_time_series/reinfection.jsp" />

	<jsp:param name="datatable" value="reinfection_time_series/tables/reinfection_table.jsp" />
	<jsp:param name="datatable_div" value="reinfections-by-date" />
	<jsp:param name="datatable_feed" value="reinfection_time_series/feeds/timeline.jsp" />
	<jsp:param name="datatable_kpis" value="count" />
	
	<jsp:param name="InitialCountSevenArray" value="true" />
</jsp:include>
