<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<style>

.links {
	stroke: #007bff;
    stroke-width: 0.5px;
    pointer-events: all;
	}
</style>

<script>

	var cbs = document.querySelectorAll('[type="checkbox"]');
	[].forEach.call(cbs, function (cb) {
	    cb.addEventListener("click", function(){
	        console.log(this.id);
	    });
	});
	$("input").on('change', function (event) {
		console.log('reached');
		console.log(event);
	 });


	let draw2 = false;
	var table2 = null;
	
	$(document).ready( function () {
		init();
		
		$.fn.dataTable.ext.search.push(
			    function( settings, searchData, index, rowData, counter ) {
			      var positions = $('input:checkbox[name="type"]:checked').map(function() {
			        return this.value;
			      }).get();
			      
			      //console.log(positions);
			   
			      if (positions.length === 0) {
			        return true;
			      }
			      
			      if (positions.indexOf(searchData[1]) !== -1) {
			        return true;
			      }
			      
			      return false;
			    }
			  );
	});

	async function init() {
		await getEdges();
		
		$.getJSON("<util:applicationRoot/>/feeds/${param.nodes}", function(data) {
			// console.log(data);
	
			var json = $.parseJSON(JSON.stringify(data));
			var col = [];

			for (i in json['headers']){
				col.push(json['headers'][i]['label']);
			}

			var table = document.createElement("table");
			table.className = 'table table-hover compact site-wrapper';
			table.style.width = '100%';
			table.id = "site-table";
			var header= table.createTHead();
			var header_row = header.insertRow(0); 

			for (i in col) {
				var th = document.createElement("th");
				th.innerHTML = '<span style="color:#333; font-weight:600; font-size:14px;">' + col[i].toString() + '</span>';
				header_row.appendChild(th);
			}
			var divContainer = document.getElementById("site-roster");
			divContainer.appendChild(table);
			data = json['sites'];
			table2 = $('#site-table').DataTable({
				data: data,
				paging: true,
				dom: 'lfr<"datatable_overflow"t>Bip',
				buttons: {
					dom: {
						button: {
							tag: 'button',
							className: ''
						}
					},
					buttons: [{
						extend: 'csv',
						className: 'btn btn-sm btn-light',
						titleAttr: 'CSV export.',
						text: 'CSV',
						filename: 'N3C_sites_csv_export',
						extension: '.csv'
					}, {
						extend: 'copy',
						className: 'btn btn-sm btn-light',
						titleAttr: 'Copy table data.',
						text: 'Copy'
					}]
				},
				pageLength: 10,
				lengthMenu: [10, 25, 50, 75, 100],
				order: [[0, 'asc']],
				columns: [
					{
						data: 'site', visible: true, orderable: true,
						render: function(data, type, row) {
							if (row.url == null)
								return '<a href="http://' + row.id + '"><span>' + row.site + '<\/span></a>';
							else
								return '<a href="' + row.url + '"><span>' + row.site + '<\/span></a>';
						}
					},
					{ data: 'type', visible: true, orderable: true },
					{ data: 'count', visible: true, className: "text-right" },
					{ data: 'aggregate_count', visible: true, className: "text-right" },
					{ data: 'target_count', visible: true, className: "text-right" },
					<c:choose>
						<c:when test="${empty param.linkage}">
							{ data: 'id', visible: false },
						</c:when>
						<c:otherwise>
							{
								data: 'id', visible: true, orderable: true,
								render: function(data, type, row) {
									return '<a href="<util:applicationRoot/>/${param.linkage}'+row.id+'">details</a>';
								}
							},
						</c:otherwise>
					</c:choose>
					{ data: 'url', visible: false },
					{ data: 'latitude', visible: false },
					{ data: 'longitude', visible: false }
				]
			});
			const tableData = getTableData(table2);
			drawColorKey();
			createD3Chart(tableData);
			setTableEvents(table2);
		});
	}
	
	function getTableData(table) {
		var tableData = {};
		const dataArray = [];
	
		table.rows({ search: "applied" }).every(function() {
			const data = this.data();
			dataArray.push(data);
		});
	
		tableData["sites"] = dataArray;
		return tableData;
	}
	
	
	//////////////////////////////////////////////// D3 VIZ /////////////////////////////////////////////////
	var width = null;
	var height = null;
	var links = null;
	var node_map = null;
	
	async function getEdges() {
		d3.json("<util:applicationRoot/>/feeds/${param.edges}", function(error, data) {
			if (error) throw error;
	
			links = data.edges;
		});		
	}
	
	function createD3Chart(sites_data) {
		d3.select("#graph").select("svg").remove();
	
		node_map = d3.map(sites_data.sites, d => d.id);
	
		// Load the Cohort Data
		d3.json("<util:applicationRoot/>/feeds/map_data.jsp", function(error, data) {
			if (error) throw error;
	
			var myObserver = new ResizeObserver(entries => {
				entries.forEach(entry => {
					var newWidth = Math.floor(entry.contentRect.width);
					// // console.log('body width '+newWidth);
					if (newWidth > 0) {
						d3.select("#graph").select("svg").remove();
						width = newWidth;
						height = (width / 2);
						draw();
					}
				});
			});
			myObserver.observe(d3.select("#graph").node());
	
			draw();
	
			function draw() {
				d3.select("#graph").select("svg").remove();
	
				// D3 Projection 
				var projection = d3.geoAlbersUsa()
					.translate([width / 2, (height / 2)]) // translate to center of screen
					.scale([width]); // scale things down so see entire US
	
				// Define path generator
				var path = d3.geoPath() // path generator that will convert GeoJSON to SVG paths
					.projection(projection); // tell path generator to use albersUsa projection
	
	
				var svg = d3.select("#graph")
					.append("svg")
					.attr("width", width)
					.attr("height", height);
	
				var g = svg.append("g");
	
				var linkScale = d3.scaleLinear()
					.domain([0, d3.max(links, function(d) { return d.count; })])
					.range([0.15, 1]);
	
				var nodeScale = d3.scaleLinear()
					.domain([0, d3.max(sites_data.sites, function(d) { return d.count; })])
					.range([3, 15]);
	
				const zoom = d3.zoom()
					.scaleExtent([1, 30])
					.on('zoom', function() {
						const { transform } = d3.event;
						g.attr('transform', transform);
						g.selectAll(".remove").attr('d', d3.symbol().type(d3.symbolCircle).size(10 / transform.k));
						g.selectAll("circle").attr('r', function(d) { return nodeScale(d.count) / transform.k; });
					});
	
				svg.call(zoom);
	
	
				// Color Scale For Legend and Map 
				var color = d3.scaleOrdinal()
					.domain(["N3C", "CTSA", "GOV", "CTR", "COM", "UNAFFILIATED", "REGIONAL", "X1", "X2", "X3"])
					.range(["#007bff", "#8406D1","#09405A", "#AD1181",  "#ffa600", "#ff7155", "#a6a6a6", "8B8B8B", "black", "yellow"]);
	
				var stroke = d3.scaleOrdinal()
					.domain(["available", "submitted", "pending"])
					.range(["#64286b", "#545454", "#545454"]);
	
				var dataArray = [];
	
				var states = data.states;
	
				for (var d = 0; d < states.length; d++) {
					dataArray.push(parseFloat(states[d].count))
				}
	
				// Load GeoJSON data and merge with cohort data
				d3.json("<util:applicationRoot/>/feeds/us-states.json", function(json) {
	
					// Loop through each state data value in the json array
					for (var i = 0; i < states.length; i++) {
						var dataState = states[i].name;
						var dataValue = states[i].count;
						var dataRegion = states[i].region;
						// Find the corresponding state inside the GeoJSON
						for (var j = 0; j < json.features.length; j++) {
							var jsonState = json.features[j].properties.name;
							if (dataState == jsonState) {
								// Copy the data value into the JSON
								json.features[j].properties.value = dataValue;
								json.features[j].properties.color = dataRegion;
								break;
							}
						}
					}
	
					// Bind the data to the SVG and create one path per GeoJSON feature
					g.selectAll("path")
						.data(json.features)
						.enter()
						.append("path")
						.attr("d", path)
						.style("stroke", "#d4d4d4")
						.style("stroke-width", "1")
						.style("fill", "#f8f9fa");
	
	
					var graph = sites_data;
					var locationBySite = [],
						positions = [];
	
					var sites = graph.sites.filter(function(site) {
						var location = [site.longitude, site.latitude];
						locationBySite[site.id] = projection(location);
						if (projection(location) == undefined)
							return false;
						positions.push(projection(location));
						return true;
					});
	
					var nodeScale = d3.scaleLinear()
						.domain([0, d3.max(sites, function(d) { return d.count; })])
						.range([3, 15]);
	
					var edges = [];
					links.filter(function(link) {
						//console.log(link);
						var source = node_map.get(link.source);
						var target = node_map.get(link.target);
						//console.log(link, source, target);
						if (source == undefined || target == undefined)
							return false;
						var count = link.count;
						var source_loc = projection([source.longitude, source.latitude]);
						var target_loc = projection([target.longitude, target.latitude]);
						//console.log(source_loc, target_loc);
						if (source_loc != undefined && target_loc != undefined)
							edges.push({ source, source_loc, target, target_loc, count })
					});
	
					var edgeScale = d3.scaleLinear()
						.domain([0, d3.max(edges, function(d) { return d.count; })])
						.range([0, 1]);
	
					var link = g.selectAll("line")
						.data(edges)
						.enter()
						.append("line")
						.attr("class", "links")
						.style("stroke-opacity", function(d) { return edgeScale(d.count); })
						.attr("x1", function(d) { return d.source_loc[0]; })
						.attr("x2", function(d) { return d.target_loc[0]; })
						.attr("y1", function(d) { return d.source_loc[1]; })
						.attr("y2", function(d) { return d.target_loc[1]; });
	
					function fade(opacity, out) {
						return function(d) {
							//				          node.style("stroke-opacity", function(o) {
							//				              thisOpacity = isConnected(d, o) ? 1 : opacity;
							//				              this.setAttribute('fill-opacity', thisOpacity);
							//				              return thisOpacity;
							//				          });
	
							link.style("stroke-opacity", function(o) {
								if (out) {
									return edgeScale(o.count);
								}
								return o.source == d || o.target == d ? 1 : opacity * edgeScale(o.count);
							});
						};
					}
					
					function collaborator_count(d) {
						var coll_count = 0;
						links.filter(function(o) {
							if (o.source == d.id || o.target == d.id)
								coll_count = coll_count + 1;
						});
						return coll_count;
					}
	
					var other = g.selectAll("circle")
						.data(sites)
						.enter().append("svg:circle")
						.style("fill", function(d) { return color(d.type); })
						.attr("fill-opacity", 1.0)
						.attr('class', "remove")
						.attr("cx", function(d, i) { return positions[i][0]; })
						.attr("cy", function(d, i) { return positions[i][1]; })
						.attr("r", function(d, i) { return nodeScale(d.count); })
						.on("mouseover", fade(.2, false))
						.on("mouseout", fade(1, true))
						.append('title')
						.text(function(d) { return ("Site: " + d.site + "\nType: " + d.type + "\n# Investigators: " + d.count + "\n# Collaborating Sites: " + collaborator_count(d)); });
	
				});
	
	
			};
		});
	
		function org_label(x) {
			return "<br>" + x;
		}
	
		function status_label(x) {
			return "<br>" + x;
		}
	
	
	}
	
	function clickfilter(){
		table2.draw();
	}
	
    function drawColorKey() {
		$.getJSON("<util:applicationRoot/>/feeds/${param.legend}", function(data) {
			var legendData = data.sites;
        	var colorScale = d3.scaleOrdinal()
				.domain(["N3C", "CTSA", "GOV", "CTR", "COM", "UNAFFILIATED", "REGIONAL", "X1", "X2", "X3"])
				.range(["#007bff", "#8406D1","#09405A", "#AD1181",  "#ffa600", "#ff7155", "#a6a6a6", "8B8B8B", "black", "yellow"]);


        	var legend_div = d3.select("#legend").append("div").attr("class", "row").attr("id", "filters");
    		
    		var legend_data = legend_div.selectAll(".new_legend")
    			.data(legendData)
    			.enter().append("div")
    			.attr("class", "col col-6 col-lg-4")
    			.html(function(d,i){
    				return  '<label class="testcheck"><input onclick="clickfilter()" class="checkbox" type="checkbox" name="type" value="' + legendData[i].org_type + '"><i class="fas fa-circle" style="color:' + colorScale(legendData[i].org_type) + ';"></i> ' +  d.org_type + " [" + d.count + "]</label>";
    			});
		});
    }
    
	
	function update(data) {
	
		var svg = d3.select("#graph").select("svg");
		var g = svg.select("g");
	
		node_map = d3.map(data.sites, d => d.id);
	
		var projection = d3.geoAlbersUsa()
			.translate([width / 2, (height / 2)]) // translate to center of screen
			.scale([width]); // scale things down so see entire US
		var graph = data;
		var locationBySite = [], positions = [];
		var sites = graph.sites.filter(function(site) {
			var location = [site.longitude, site.latitude];
			locationBySite[site.id] = projection(location);
			if (projection(location) == undefined)
				return false;
			positions.push(projection(location));
			return true;
		});
	
		var edges = [];
		links.filter(function(link) {
			//console.log(link);
			var source = node_map.get(link.source);
			var target = node_map.get(link.target);
			var count = link.count;
			if (source != undefined && target != undefined) {
				var source_loc = projection([source.longitude, source.latitude]);
				var target_loc = projection([target.longitude, target.latitude]);
				//console.log(source_loc, target_loc);
				if (source_loc != undefined && target_loc != undefined)
					edges.push({ source, source_loc, target, target_loc, count })
			}
		});
	
		var edgeScale = d3.scaleLinear()
			.domain([0, d3.max(edges, function(d) { return d.count; })])
			.range([0, 1]);
	
		var nodeScale = d3.scaleLinear()
			.domain([0, d3.max(sites, function(d) { return d.count; })])
			.range([2, 15]);
	
		const zoom = d3.zoom()
			.scaleExtent([1, 30])
			.on('zoom', function() {
				const { transform } = d3.event;
				g.attr('transform', transform);
				g.selectAll(".remove").attr('d', d3.symbol().type(d3.symbolCircle).size(10 / transform.k));
				g.selectAll("circle").attr('r', function(d) { nodeScale(d.count) / transform.k; });
			});
	
		d3.select("#graph").select("svg").selectAll("line").remove();
	
		var link = g.selectAll("line")
			.data(edges)
			.enter()
			.append("line")
			.attr("class", "links")
			.style("stroke-opacity", function(d) { return edgeScale(d.count); })
			.attr("x1", function(d) { return d.source_loc[0]; })
			.attr("x2", function(d) { return d.target_loc[0]; })
			.attr("y1", function(d) { return d.source_loc[1]; })
			.attr("y2", function(d) { return d.target_loc[1]; });
	
		function fade(opacity, out) {
			return function(d) {
				//		          node.style("stroke-opacity", function(o) {
				//		              thisOpacity = isConnected(d, o) ? 1 : opacity;
				//		              this.setAttribute('fill-opacity', thisOpacity);
				//		              return thisOpacity;
				//		          });
	
				link.style("stroke-opacity", function(o) {
					if (out) {
						return edgeScale(o.count);
					}
					return o.source == d || o.target == d ? 1 : opacity * edgeScale(o.count);
				});
			};
		}
	
		var color = d3.scaleOrdinal()
			.domain(["N3C", "CTSA", "GOV", "CTR", "COM", "UNAFFILIATED", "REGIONAL", "X1", "X2", "X3"])
			.range(["#007bff", "#8406D1","#09405A", "#AD1181",  "#ffa600", "#ff7155", "#a6a6a6", "8B8B8B", "black", "yellow"]);
	
		var ochin_check = [];
		for (i in data["sites"]) {
			ochin_check.push(data["sites"][i]["site"])
		};
	
		d3.select("#graph").select("svg").selectAll("path.remove").remove();
	
		var path = g.selectAll("path.return").data(sites);
		path.exit().remove();
	
		d3.select("#graph").select("svg").selectAll("circle.remove").remove();
	
		function collaborator_count(d) {
			var coll_count = 0;
			links.filter(function(o) {
				if (o.source == d.id || o.target == d.id)
					coll_count = coll_count + 1;
			});
			return coll_count;
		}

		var circle = g.selectAll("circle.return").data(sites);
	
		circle
			.enter().append("circle")
			.attr("class", "remove")
			.style("fill", function(d) { return color(d.type); })
			.attr("fill-opacity", 1.0)
			.attr("cx", function(d, i) { return positions[i][0]; })
			.attr("cy", function(d, i) { return positions[i][1]; })
			.attr("r", function(d, i) { return nodeScale(d.count); })
			.on("mouseover", fade(.2, false))
			.on("mouseout", fade(1, true))
			.append('title')
			.text(function(d) { return ("Site: " + d.site + "\nType: " + d.type + "\n# Investigators: " + d.count+ "\n# Collaborating Sites: " + collaborator_count(d)); });;
	
	
		circle.exit().remove();
	
	
	
	}
	
	function setTableEvents(table) {
	
		table.on("page", function() {
			draw2 = true;
		});
	
		// listen for updates and adjust the chart accordingly
		table.on("draw", function() {
			if (draw2) {
				draw2 = false;
				return;
			} else {
				const tableData = getTableData(table);
	
				update(tableData);
			}
		});
	}



</script>
