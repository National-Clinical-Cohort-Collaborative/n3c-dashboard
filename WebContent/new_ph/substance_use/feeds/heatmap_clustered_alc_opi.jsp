<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="graph" uri="http://slis.uiowa.edu/graphtaglib"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="community_steps" scope="request" value="0.01 0.1 1 10 100" />

<graph:graph>
    <sql:query var="projects" dataSource="jdbc/N3CPublic" >
    	select secondary_seqnum as alcohol_condition_seqnum,alcohol_condition,sum(all_count) as all_count,sum(covid_count) as covid_count
    	from n3c_dashboard.alcohol_map join n3c_dashboard_ph.substance_alc_opi_combined on (alcohol_condition = secondary)
    	group by 1,2 order by 1;
    </sql:query>
    <c:forEach items="${projects.rows}" var="row">
    	<c:choose>
    		<c:when test="${not empty param.covid_count}">
		        <graph:node uri="alcohol_${row.alcohol_condition_seqnum}" label="${row.alcohol_condition}" group="0" score="${row.covid_count}" auxString="alcohol"/>
    		</c:when>
    		<c:when test="${not empty param.all_count}">
		        <graph:node uri="alcohol_${row.alcohol_condition_seqnum}" label="${row.alcohol_condition}" group="0" score="${row.all_count}" auxString="alcohol"/>
    		</c:when>
    		<c:otherwise>
		        <graph:node uri="alcohol_${row.alcohol_condition_seqnum}" label="${row.alcohol_condition}" group="0" score="${row.all_count}" auxString="alcohol"/>
    		</c:otherwise>
    	</c:choose>
    </c:forEach>
		
    <sql:query var="persons" dataSource="jdbc/N3CPublic" >
    	select secondary_seqnum as opioids_seqnum,opioids,sum(all_count) as all_count,sum(covid_count) as covid_count
    	from n3c_dashboard.opioid_map join n3c_dashboard_ph.substance_alc_opi_combined on (opioids = secondary)
    	group by 1,2 order by 1;
    </sql:query>
    <c:forEach items="${persons.rows}" var="row">
    	<c:choose>
    		<c:when test="${not empty param.covid_count}">
		        <graph:node uri="opioid_${row.opioids_seqnum}" label="${row.opioids}" group="0" score="${row.covid_count}" auxString="opioid"/>
    		</c:when>
    		<c:when test="${not empty param.all_count}">
		        <graph:node uri="opioid_${row.opioids_seqnum}" label="${row.opioids}" group="0" score="${row.all_count}" auxString="opioid"/>
    		</c:when>
    		<c:otherwise>
		        <graph:node uri="opioid_${row.opioids_seqnum}" label="${row.opioids}" group="0" score="${row.all_count}" auxString="opioid"/>
    		</c:otherwise>
    	</c:choose>
    </c:forEach>

    <sql:query var="edges" dataSource="jdbc/N3CPublic">
         select alcohol_map.secondary_seqnum as alcohol_condition_seqnum,opioid_map.secondary_seqnum as opioids_seqnum,
         greatest(all_count,1) as all_weight,
         greatest(covid_count,1) as covid_weight,
         all_count,
         covid_count
         from n3c_dashboard_ph.substance_alc_opi_combined
         join n3c_dashboard.alcohol_map on (alcohol_map.secondary = alcohol_condition)
         join n3c_dashboard.opioid_map on (opioid_map.secondary = opioids);
    </sql:query>
    <c:forEach items="${edges.rows}" var="row">
    	<c:choose>
    		<c:when test="${not empty param.covid_count}">
		      <graph:edge source="alcohol_${row.alcohol_condition_seqnum}" target="opioid_${row.opioids_seqnum}"  weight="${row.covid_weight}" auxInt="${row.covid_count}" />
      		</c:when>
    		<c:when test="${not empty param.all_count}">
		      <graph:edge source="alcohol_${row.alcohol_condition_seqnum}" target="opioid_${row.opioids_seqnum}"  weight="${row.all_weight}" auxInt="${row.all_count}" />
    		</c:when>
    		<c:otherwise>
		      <graph:edge source="alcohol_${row.alcohol_condition_seqnum}" target="opioid_${row.opioids_seqnum}"  weight="${row.all_weight}" auxInt="${row.all_count}" />
    		</c:otherwise>
    	</c:choose>
    </c:forEach>

	    <c:forEach var="step" items="${fn:split(community_steps, ' ')}">
			<graph:graphColorer auxdouble="${step}" algorithm="edu.uiowa.slis.graphtaglib.CommunityDetection.LouvainWrapper"/>
			<graph:graphColorer auxdouble="${step}" algorithm="edu.uiowa.slis.graphtaglib.CommunityDetection.LouvainMultilevelRefinementWrapper"/>
			<graph:graphColorer auxdouble="${step}" algorithm="edu.uiowa.slis.graphtaglib.CommunityDetection.SmartLocalMovingWrapper"/>
	    </c:forEach>

	{
	  "nodes":[
		<graph:foreachNode > 
			<graph:node auxDouble="${param.resolution}" coloring="${param.detectionAlg}">
			    {"url":"<graph:nodeUri/>","name":"<graph:nodeLabel/>","group":"<graph:nodeAuxString/>","score":<graph:nodeScore/>,
			</graph:node>
			<graph:node auxDouble="${param.resolution}" coloring="site">
			    "site":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="0.01" coloring="Louvain">,
			    "Louvain001":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="0.1" coloring="Louvain">,
			    "Louvain01":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="1" coloring="Louvain">,
			    "Louvain1":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="10" coloring="Louvain">,
			    "Louvain10":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="100" coloring="Louvain">,
			    "Louvain100":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="0.01" coloring="LouvainMultilevelRefinement">,
			    "LouvainMultilevelRefinement001":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="0.1" coloring="LouvainMultilevelRefinement">,
			    "LouvainMultilevelRefinement01":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="1" coloring="LouvainMultilevelRefinement">,
			    "LouvainMultilevelRefinement1":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="10" coloring="LouvainMultilevelRefinement">,
			    "LouvainMultilevelRefinement10":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="100" coloring="LouvainMultilevelRefinement">,
			    "LouvainMultilevelRefinement100":<graph:nodeGroup/>
			</graph:node>
					<graph:node auxDouble="0.01" coloring="SmartLocalMoving">,
			    "SmartLocalMoving001":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="0.1" coloring="SmartLocalMoving">,
			    "SmartLocalMoving01":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="1" coloring="SmartLocalMoving">,
			    "SmartLocalMoving1":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="10" coloring="SmartLocalMoving">,
			    "SmartLocalMoving10":<graph:nodeGroup/>
			</graph:node>
			<graph:node auxDouble="100" coloring="SmartLocalMoving">,
			    "SmartLocalMoving100":<graph:nodeGroup/>}<c:if test="${ ! isLastNode }">,</c:if>
			</graph:node>
		</graph:foreachNode>
		],
	  "links":[
	  	<graph:foreachEdge>
	  		<graph:edge>
			    {"source":<graph:edgeSource/>,"target":<graph:edgeTarget/>,"value":<graph:edgeAuxInt/>}<c:if test="${ ! isLastEdge }">,</c:if>
	  		</graph:edge>
	  	</graph:foreachEdge>
	  ]
	}
	
	
</graph:graph>
