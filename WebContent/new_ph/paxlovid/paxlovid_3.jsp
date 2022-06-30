<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<jsp:include page="kpis.jsp"/>

<jsp:include page="../block2.jsp">
	<jsp:param name="block" value="paxlovid_3" />
	<jsp:param name="block_header" value="Paxlovid" />
	<jsp:param name="topic_description" value="secondary_1" />
	<jsp:param name="topic_title" value="Demographics of Patients With Paxlovid" />
	
	<jsp:param name="simple_panel" value="medication_snapshot/visits.jsp" />

	<jsp:param name="datatable" value="medication_snapshot/visits_table.jsp" />
	<jsp:param name="datatable_div" value="medication_snapshot_paxlovid_visits" />
	<jsp:param name="datatable_feed" value="medication_snapshot/feeds/visits.jsp" />
</jsp:include>

<script>
	paxlovid_3_toggle("category");
</script>