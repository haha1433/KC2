<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script type="text/javascript" src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="http://d3js.org/d3.v3.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#sDate, #eDate").datepicker({
		dateFormat: 'yymmdd'
	});
	
	$(".help").mouseover(function(e){
		var popupid = $(this).attr("id") + "_help";
		var x = e.pageX, y = e.pageY; 
		$("#"+popupid).css({
			"left": x+"px",
			"top": y+"px"
		}).show();
	}).mouseout(function(e){
		var popupid = $(this).attr("id") + "_help";
		$("#"+popupid).hide();
	});
	
	// 클릭시 그래프 생성
	$(document).on("click", "#stocksList li", function(){
		if($(this).hasClass("fRow")){
			return false;
		}
		var issuecode = $(this).attr("issuecode");
		var sDate = $("#sDate").val();
		var eDate = $("#eDate").val();
		var stockChartObj = $(this).find(".stockChart"); 
		if(stockChartObj.css("display") == "none"){
			$(".stockChart").slideUp();
			stockChartObj.slideDown();
			// 그래프 생성
			var margin = {top: 30, right: 40, bottom: 40, left: 50},
			    width = $(this).width() - margin.left - margin.right,
			    height = 300 - margin.top - margin.bottom,
			    padding = 0.3;
			
			var x = d3.scale.ordinal()
			    .rangeRoundBands([0, width], padding);
			
			var y = d3.scale.linear()
			    .range([height, 0]);
			
			var xAxis = d3.svg.axis()
			    .scale(x)
			    .orient("bottom");
			
			var yAxis = d3.svg.axis()
			    .scale(y)
			    .orient("left")
			    .tickFormat(function(d) { return dollarFormatter(d); });
			
			var chart = d3.select(".chart_"+issuecode)
			    .attr("width", width + margin.left + margin.right)
			    .attr("height", height + margin.top + margin.bottom)
			  .append("g")
			    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
			
			d3.csv("data.csv?issuecode="+issuecode+"&sDate="+sDate+"&eDate="+eDate, type, function(error, data) {
			
			  // Transform data (i.e., finding cumulative values and total) for easier charting
			  var cumulative = 0;
			  for (var i = 0; i < data.length; i++) {
			    data[i].start = cumulative;
			    cumulative += data[i].value;
			    data[i].end = cumulative;
			
			    data[i].class = ( data[i].value >= 0 ) ? 'positive' : 'negative'
			  }
			  data.push({
			    name: 'Total',
			    end: cumulative,
			    start: 0,
			    class: 'total'
			  });
			
			  x.domain(data.map(function(d) { return d.name; }));
			  y.domain([0, d3.max(data, function(d) { return d.end; })]);
			
			  chart.append("g")
			      .attr("class", "x axis")
			      .attr("transform", "translate(0," + height + ")")
			      .call(xAxis);
			
			  chart.append("g")
			      .attr("class", "y axis")
			      .call(yAxis);
			
			  var bar = chart.selectAll(".bar")
			      .data(data)
			    .enter().append("g")
			      .attr("class", function(d) { return "bar " + d.class })
			      .attr("transform", function(d) { return "translate(" + x(d.name) + ",0)"; });
			
			  bar.append("rect")
			      .attr("y", function(d) { return y( Math.max(d.start, d.end) ); })
			      .attr("height", function(d) { return Math.abs( y(d.start) - y(d.end) ); })
			      .attr("width", x.rangeBand());
			
			  bar.append("text")
			      .attr("x", x.rangeBand() / 2)
			      .attr("y", function(d) { return y(d.end) + 5; })
			      .attr("dy", function(d) { return ((d.class=='negative') ? '-' : '') + ".75em" })
			      .text(function(d) { return dollarFormatter(d.end - d.start);});
			
			  bar.filter(function(d) { return d.class != "total" }).append("line")
			      .attr("class", "connector")
			      .attr("x1", x.rangeBand() + 5 )
			      .attr("y1", function(d) { return y(d.end) } )
			      .attr("x2", x.rangeBand() / ( 1 - padding) - 5 )
			      .attr("y2", function(d) { return y(d.end) } )
			});
			
			function type(d) {
			  d.value = +d.value;
			  return d;
			}
			
			function dollarFormatter(n) {
			  return Number(n).toLocaleString('en').split(".")[0] + "원";
			}

		}else{
			stockChartObj.slideUp();
		}
	});
});
</script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<style type="text/css">
* { margin: 0px; padding: 0px; }
li { list-style-type: none; }
#topWrap { padding: 10px; font-size: 20pt; background-color: #f39c11; color: #fff; text-align: center; }
#searchForm li { margin: 10px; text-align: center; }
#searchForm li span { width: 20%; display: inline-block; padding: 10px; color: #fff; background-color: #f39c11; border-radius: 10px; border: #847b7b; text-align: center; }
#searchForm li input,
#searchForm li select { width: 20%; display: inline-block; padding: 10px 5px; text-align: center; box-sizing: content-box; }
#searchForm li #submitBtn { background-color: #f39c11; color: #fff; font-weight: bold; }
#searchForm li input.edate { margin-left: 10px; }
#view { margin: 20px; }
#stocksList li { padding: 10px 0px; text-align: center; overflow: hidden; cursor: pointer; border-bottom: 1px solid #d0d0d0; }
#stocksList li.fRow { background-color: #eaeaea; cursor: default; border-top: 1px solid #d0d0d0; }
#stocksList li .no { float: left; width: 20%; }
#stocksList li .isuKor { float: left; width: 50%; }
#stocksList li .udp { float: left; width: 25%; }
.plus { color: red; }
.minus { color: blue; }
.hidden { display: none; }
.helpPop { background-color: #fff;padding: 5px 10px;border: 1px solid #dadada; position: absolute; }
.stockChart { height: 300px; }
.bar.total rect { fill: #ff9400; }
.bar.positive rect { fill: red; }
.bar.negative rect { fill: blue; }
.bar line.connector { stroke: grey; stroke-dasharray: 3; }
.bar text { fill: white; font: 12px sans-serif; text-anchor: middle; }
.axis text { font: 10px sans-serif; }
.axis path,
.axis line { fill: none; stroke: #000; shape-rendering: crispEdges; }
</style>
<title>3조</title>
</head>
<body>

<div id="topWrap">
	<span>종목 조회</span>
</div>

<div id="searchForm">
	<ul>
		<form method="GET" action="/">
		<li>
			<span class="help" id="searchDate">검색기간</span>
			<input type="text" id="sDate" name="sDate" value="${sdate}" placeholder="시작기간" readonly />
			<input type="text" id="eDate" name="eDate" value="${edate}" placeholder="종료기간" readonly />
		</li>
		<li>
			<span class="help" id="searchCode">종목분류</span>
			<select name="cate1">
			<c:forEach begin="0" end="${codeList.length() - 1 }" var="index">
			<option value="${codeList.getJSONObject(index).getString("code") }" ${(codeList.getJSONObject(index).getString("code") eq cate1 ? 'selected' : '')}>${codeList.getJSONObject(index).getString("name") }</option>
			</c:forEach>
			</select>
			
			<input id="submitBtn" type="submit" value="검색" />
		</li>
		</form>
	</ul>
</div>

<div id="view">
	<!-- 종목 리스트 -->
	<div id="stocksList">
		<ul>
			<li class="fRow">
				<span class="no">No.</span>
				<span class="isuKor">종목명</span>
				<span class="udp">등락가격</span>
			</li>
			<c:forEach begin="0" end="${marketList.length() -1}" var="index">
			<c:set var="data" value="${marketList.getJSONObject(index) }"></c:set>
			<c:set var="udp" value="${data.getString('difPrice') }"></c:set>
			<li issuecode="${data.getString("stockcode") }">
				<span class="no">${index+1 } </span>
				<span class="isuKor">${data.getString("stockname")}</span>
				<span class="udp ${(udp > 0 ? 'plus' : 'minus')}"><fmt:formatNumber value="${udp}" pattern=""/></span>
				<div class="hidden stockChart">
					<svg class="chart_${data.getString("stockcode") }"></svg>
				</div>
			</li>
			</c:forEach>
		</ul>
	</div>
	<!-- //종목 리스트 -->
</div>

<!-- 도움말 -->
<div class="hidden helpPop" id="searchDate_help">
원하는 날짜를 선택해주세요
</div>
<div class="hidden helpPop" id="searchCode_help">
원하는 업종을 선택해주세요
</div>
</body>
</html>