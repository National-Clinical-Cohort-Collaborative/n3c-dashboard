<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<style>
	rect{
		cursor: auto;
	}

    .axis path,
    .axis line {
        fill: none;
        stroke: #000;
        shape-rendering: crispEdges;
    }

    .x.axis path {
        display: none;
    }
    
    .xaxis text{
    	fill: #000;
    }

    .line {
        fill: none;
        stroke-width: 1.5px;
    }

    .overlay {
        fill: none;
        pointer-events: bounding-box;
    }
	
	.tooltip-duas,
	text.duas{
        fill: ${column1_color} ;
    }
    
    .dua_dta_focus{
    	fill: black;
    	pointer-events:none;
    }
    
    .tool_line{
    	pointer-events:none;
    }
    .dua_dta_focus .tooltip{
    	opacity: 0.7;
    	stroke:none;
    	width: 160px;
    }
    
    path.duas,
    rect.duas{
    	stroke: ${column1_color} ;
    	stroke-width:3.8px;
    }
    path.dtas,
    rect.dtas{
    	stroke: ${column2_color} ;
    	stroke-width:3.8px;
    }
    
    .tooltip-dtas, text.dtas{
    		fill: ${column2_color} ;
    }
    
    .dua_dta_focus text{
        font-size: 12px;
    }

    .tooltip {
        fill: white;
        stroke: #000;
    }

    .tooltip-date_dta_dua, 
    .tooltip-duas, 
    .tooltip-dtas{
        font-weight: bold;
    }

.axis1 text{
  fill: ${column1_color} ;
  fill: black ; 
}

.axis2 text{
  fill: ${column2_color} ;
}
</style>

	

<script>


function LineNColumnChart(data, properties) {

	// set the dimensions and margins of the graph
	var margin = {top: 0, right: 100, bottom: 100, left: 100},
	    width = 960 - margin.left - margin.right,
	    height = 600 - margin.top - margin.bottom;
	
	
	var keys =  Object.keys(data[0].elements);
	var maxCount = 0;
	for (let i = 0; i < data.length; i++) {
		for (let j = 0; j < keys.length; j++) {
			maxCount = Math.max(maxCount, data[i].elements[keys[j]]);
		}
	};
//	console.log("maxCount", maxCount, "keys", keys)

	var column1_label = properties.yaxis_label;
		var column_tip_offset = 120;
		var column1_opacity = 1;
		var column2_opacity = 0.5;
		
		var ${param.block}myObserver = new ResizeObserver(entries => {
			entries.forEach(entry => {
				var newWidth = Math.floor(entry.contentRect.width);
				if (newWidth > 0) {
					d3.select("#"+properties.domName).select("svg").remove();
					width = newWidth - margin.left - margin.right;
					if ((width/1.75 - margin.top - margin.bottom) > 200){
						height = width/1.75 - margin.top - margin.bottom;
					} else { 
						height = 200;
					}
					draw();
				}
			});
		});
		
		${param.block}myObserver.observe(d3.select("#"+properties.domName).node());
		
		draw();
		
		
		function draw() {
			// set the ranges
			var startValue = data[0].timeline;
			var endValue = data[data.length-1].timeline;

			var x = d3.scaleLinear().domain([startValue, endValue]).range([0, width]);
			var y = d3.scaleLinear().domain([0.8,maxCount]).range([height, 10]);
			var line = d3.line().x(d => x(d.timeline)).y(d => y(d.timeline));
			
			
		
			// append the svg obgect to the body of the page
			// appends a 'group' element to 'svg'
			// moves the 'group' element to the top left margin
			var svg = d3.select("#"+properties.domName).append("svg")
				.attr("class", "clear_target")
				.attr("width", width + margin.left + margin.right)
				.attr("height", height + margin.top + margin.bottom)
				.append("g")
				.attr("transform", "translate(" + margin.left + "," + margin.top + ")");
			
			// Add a clipPath: everything out of this area won't be drawn.
			 var clip = svg.append("defs").append("svg:clipPath")
			     .attr("id", "clip")
			     .append("svg:rect")
			     .attr("width",width)
			     .attr("height", height)
			     .attr("x", 0)
			     .attr("y", 0);
			
			
			    // Create the scatter variable: where both the circles and the brush take place
			  var graph = svg.append('g')
    			  .attr("clip-path", "url(#clip)")
    			  .attr("class", "overlay");
			 
			  
			// Add brushing
			  var brush = d3.brushX()                   // Add the brush feature using the d3.brush function
			      .extent( [ [0,0], [width,height] ] )  // initialise the brush area: start at 0,0 and finishes at width,height: it means I select the whole graph area
			      .on("brush", dua_dta_mousemove)
			      .on("end", updateChart);              // Each time the brush selection changes, trigger the 'updateChart' function
			  
				// X & Y 
				for (let i = 0; i < keys.length; i++) {
					var valueline = d3.line()
			            .curve(d3.curveMonotoneX)
						.x(function(d) { return x(d.timeline); })
						.y(function(d) { return y(d.elements[keys[i]]); });
					
					graph.append("path")
						.data([data])
						.attr("opacity", column1_opacity)
						.attr("class", "line_"+i)
						.attr("stroke", function (d){
							var color = properties.legend_labels.indexOf(keys[i]);
							return categorical8[color];
						})
						.attr("stroke-width", '3px')
						.attr("d", valueline);
				}
			      
				
				
				// Add the brushing
				var test_tip = graph
				    .append("g")
				    .attr("class", "brush")
				    .call(brush)
				    .on("mouseover", function() { dua_dta_focus.style("display", null);  tooltipLine.style("display", null);})
		    	  	.on("mouseout", function() { dua_dta_focus.style("display", "none");  tooltipLine.style("display", "none");})
		    	  	.on("mousemove", dua_dta_mousemove);
			
				// Labels & Current Totals
				<c:if test="not empty param.lineLabels">
					graph.append("text")
				    	.attr("transform", "translate("+(width+3)+","+y(data[data.length-1].column1)+")")
				    	.attr("dy", ".35em")
				    	.attr("text-anchor", "start")
				    	.attr("class", "duas")
				    	.text("column1_tip");
					graph.append("text")
				    	.attr("transform", "translate("+(width+3)+","+y(data[data.length-1].column2)+")")
				    	.attr("dy", ".35em")
				    	.attr("text-anchor", "start")
				    	.attr("class", "dtas")
				    	.text("column2_tip");
				</c:if>
				

			    
			  	// Axis
				var xaxis = svg.append("g")
					.attr("transform", "translate(0," + height + ")")
					.attr("class", "xaxis")
					.call(d3.axisBottom(x).tickFormat(function(timeline){
						return timeline;
					      }))
					.selectAll("text")  
    					.style("text-anchor", "middle")
    					.style("font-size", "12px")
    					.attr("dy", "1.5em");

				// text label for the x axis
				  svg.append("text")             
				      .attr("transform",
				            "translate(" + (width/2) + " ," + (height + 60) + ")")
				      .style("text-anchor", "middle")
				      .text(properties.xaxis_label)
				      .attr("font-size", '14px')
					  .attr("font-weight", "bold");

				  svg.append("g")
			      .attr("class", "axis1")
			      .call(d3.axisLeft(y).ticks(10));

				  // text label for the y axis
				  svg.append("text")
				  	.attr("transform", "rotate(-90)")
				  	.attr("y", 0 - margin.left)
				  	.attr("x",0 - (height / 2))
				  	.attr("dy", "1em")
				  	.style("text-anchor", "middle")
				  	.text(column1_label)
				  	.attr("font-size", '14px');      
				  
				  d3.select(".axis1").selectAll('text').style("fill", "${column1_color}").style("font-size", "12px");
				
				  if (typeof properties.legendid == 'undefined') {
			        // Add the Legend
				    var lineLegend = svg.selectAll(".lineLegend").data(properties.legend_labels)
				    	.enter().append("g")
				    	.attr("class","lineLegend")
				    	.attr("transform", function (d, i) {
				            return "translate(" + (5) + "," + ( ((i*15))+20)+")";
				        });
	
				    
					lineLegend.append("text")
						.text(function (d) {return d;})
						.on("click", function(d, i){
							console.log("legend click",d,i)
							var format = {};
							format['secondary_name'] = d;
							window[properties.domName.replace(/_[^_]+_[^_]+$/i,'_')+'viz_constrain'](format, "Medications"); 
						})
					    .attr("transform", "translate(25, 6)"); //align texts with boxes
		
					lineLegend.append("rect")
					    .attr("width", 22)
					    .attr("class", function(d){return d.tag;})
					    .attr("opacity", function(d){return d.opacity;})
					    .attr("stroke",  function(d,i){
					    	return categorical8[i];
					    })
						.on("click", function(d, i){
							console.log("legend click",d,i)
							var format = {};
							format['secondary_name'] = d;
							window[properties.domName.replace(/_[^_]+_[^_]+$/i,'_')+'viz_constrain'](format, "Medications"); 
						})
					    .attr("stroke-width", '2.8px')
					    .attr('height', 2);
				  };
				    
				//tooltip line
				var tooltipLine = graph.append('line')
					.attr("class", "tool_line");
				
				// tooltips
				var dua_dta_focus = test_tip.append("g")
			    	.attr("class", "dua_dta_focus")
			    	.style("display", "none");
			
				dua_dta_focus.append("rect")
			    	.attr("class", "tooltip")
			    	.attr("height", function(d) {
				    	return (40 + (15 * keys.length));
			    	})
			    	.attr("x", 10)
			    	.attr("y", -22)
			    	.attr("rx", 4)
			    	.attr("ry", 4);
			
				dua_dta_focus.append("text")
			    	.attr("class", "tooltip-date_dta_dua")
			    	.attr("x", 18)
			    	.attr("y", 0);
			
				for (let i = 0; i < keys.length; i++) {
					dua_dta_focus.append("text")
				    	.attr("x", 18)
				    	.attr("y", 18+i*15)
				    	.attr("fill", function(d){
				    		var color = properties.legend_labels.indexOf(keys[i]);
							return categorical8[color];
				    	})
				    	.text(labelFormatter(keys[i])+":");
					dua_dta_focus.append("text")
			    	.attr("class", "tooltip-"+i)
			    	.attr("x", column_tip_offset)
			    	.attr("y", 18+i*15);
				}
				
				var parseDate = d3.timeFormat("%m/%e/%Y").parse,
					bisectDate_dua_dta = d3.bisector(function(d) { return d.timeline; }).left,
					formatValue1 = d3.format(","),
					formatValue2 = d3.format(",.2f"),
					dateFormatter = d3.timeFormat("%m/%y"),
					dateFormatter2 = d3.timeFormat("%Y-%m-%d");
				
				function labelFormatter(value) {
					if (value.length > 12)
						return value.substring(0,10)+"..."
					else
						return value
				}
				function valueFormatter1(value) {
					if (value == '<20')
						return value;
					return formatValue1(value);
				}
			
				function valueFormatter2(value) {
					if (value == '<20')
						return value;
					return formatValue2(value);
				}

				function dua_dta_mousemove() {
				    var x0 = x.invert(d3.mouse(this)[0]),
				        i = bisectDate_dua_dta(data, x0),
				        d0 = data[i - 1],
				        d1 = data[i];
					
					if (d0 && !d1){
				    	d1 = d0;
				    };
				    
				    if (d1 && !d0){
				    	d0 = d1;
				    };

				    
				    var d = x0 - d0.timeline > d1.timeline - x0 ? d1 : d0;
				    
				    
				    if (width/2 > d3.mouse(this)[0]){
				    	dua_dta_focus.attr("transform", "translate(" + x(d.timeline) + "," + d3.mouse(this)[1] + ")");
				    }else{
				    	dua_dta_focus.attr("transform", "translate(" + ((x(d.timeline))-175) + "," + d3.mouse(this)[1] + ")");
				    };
				   
				    dua_dta_focus.select(".tooltip-date_dta_dua").text("Day " + d.timeline);
					for (let i = 0; i < keys.length; i++) {
					    dua_dta_focus.select(".tooltip-"+i).text(valueFormatter1(d.elements[keys[i]]));						
					}

				    tooltipLine.attr('stroke', 'black')
				    	.attr("transform", "translate(" + x(d.timeline) + "," + 0 + ")")
				    	.attr('y1', 0)
				    	.attr('y2', height);
				};


				
				// A function that set idleTimeOut to null
				  var idleTimeout;
				  function idled() { idleTimeout = null; };
				
				// A function that update the chart for given boundaries
				   function updateChart() {

						// What are the selected boundaries?
						var extent = d3.event.selection;

				      	// If no selection, back to initial coordinate. Otherwise, update X axis domain
				     	if(!extent){
				        	if (!idleTimeout) return idleTimeout = setTimeout(idled, 350); // This allows to wait a little bit
				        	x.domain([startValue, endValue]);
				      	}else{
				        	<c:if test="${not empty param.constraintPropagator}">
				        		${param.block}_${param.constraintPropagator}(dateFormatter2(x.invert(extent[0])),dateFormatter2(x.invert(extent[1])))
				        	</c:if>
				      		x.domain([ x.invert(extent[0]), x.invert(extent[1]) ]);
				        	graph.select(".brush").call(brush.move, null); // This remove the grey brush area as soon as the selection has been done
				      	}
				      		
					      
				      	// redraw axis
				      	d3.selectAll('.xaxis').remove();
				      	svg.append("g")
						.attr("transform", "translate(0," + height + ")")
						.attr("class", "xaxis")
						.call(d3.axisBottom(x)
			        	.tickFormat(function(timeline){
							return timeline;
						      }))
						.selectAll("text")  
    						.style("text-anchor", "end")
    						.attr("dx", "-.8em")
    						.attr("dy", ".15em")
    						.style("font-size", "12px")
    						.attr("transform", "rotate(-65)");

				      	// Update line position
						for (let i = 0; i < keys.length; i++) {
					      	graph
					          .select("path.line_"+i)
					          .transition()
					          .duration(1000)
					          .attr("d", d3.line()
					            .curve(d3.curveMonotoneX)
					            .x(function(d) { return x(d.timeline); })
					            .y(function(d) { return y(d.elements[keys[i]]); }));
						}
	
				};
				
				// draw color key on to decoupled div
				function drawColorKey() {
					d3.select("#" + properties.legendid).html("");
		        	var legend_div = d3.select("#" + properties.legendid).append("div").attr("class", "row").attr("id", "floating_legend");
		        	
		        	legend_div.selectAll(".legend-title")
		        		.data([properties.legendlabel])
		    			.enter().append("div")
		        		.attr("class", "col col-12")
		        		.html(function(d){
		    				return  '<h5></i>   ' + d + ' Legend</h5>';
		    			});
		        	
		    		var legend_data = legend_div.selectAll(".new_legend")
		    			.data(properties.legend_labels)
		    			.enter().append("div")
		    			.attr("class", "col col-12 col-lg-4")
		    			.html(function(d,i){
		    				return  '<i class="fas fa-circle" style="color:' + categorical8[i] + ';"></i> ' +  d;
		    			});
			    };
			    
			    if (typeof properties.legendid !== 'undefined') {
			    	drawColorKey();
			    };
				
				function line_clear(){
		        	<c:if test="${not empty param.constraintPropagator}">
						${param.block}_${param.constraintPropagator}(null, null)
		        	</c:if>
					
					x.domain([startValue, endValue]);
					
					
					d3.select(properties.domName + " ${param.dom_element}_graph .xaxis")
			        	.transition()
			        	.call(d3.axisBottom(x)
			        	.tickFormat(function(timeline){
							return timeline;
					      	}))
						.selectAll("text")  
    						.style("text-anchor", "end")
    						.attr("dx", "-.8em")
    						.attr("dy", ".15em")
    						.attr("transform", "rotate(-65)");
			        
			        graph
			          .select('path.duas')
			          .transition()
			          .attr("d", d3.line()
			          	.x(function(d) { return x(d.timeline); })
					    .y(function(d) { return y(d.cloumn1); }));
			        
			        graph
			          .select('path.dtas')
			          .transition()
			          .attr("d", d3.line()
			          	.x(function(d) { return x(d.timeline); })
					    .y(function(d) { return y(d.column2); }));
					
				};
				
				d3.select(properties.domName + " ${param.dom_element}_graph .clear_target")
					.on("dblclick", line_clear);
				
				$("${param.dom_element}_btn").off().on("click", function(){
					d3.select(properties.domName + " ${param.dom_element}_graph .clear_target").dispatch("dblclick");
				});
				
			};
}
</script>
