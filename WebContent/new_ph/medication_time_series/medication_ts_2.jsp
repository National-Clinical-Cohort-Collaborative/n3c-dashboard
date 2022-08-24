<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<jsp:include page="../block2.jsp">
	<jsp:param name="block" value="medication_ts_2" />
	<jsp:param name="block_header" value="Medication Time Series" />

	<jsp:param name="kpis" value="medication_time_series/kpis.jsp" />

	<jsp:param name="simple_panel" value="medication_time_series/overall.jsp" />

	<jsp:param name="datatable" value="medication_time_series/overall_table.jsp" />
	<jsp:param name="datatable_div" value="medications-overall" />
	<jsp:param name="datatable_feed" value="medication_time_series/feeds/overall.jsp" />
</jsp:include>