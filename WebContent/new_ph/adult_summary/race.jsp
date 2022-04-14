<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>


<div id="${param.block}_race_viz" class="col-lg-7"></div>
<script>
	${param.block}_refreshHistograms();
	console.log("race graph", "${param.block}_race_viz", ${param.block}_raceArray)
</script>