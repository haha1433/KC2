<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script type="text/javascript">
var apikey = "l7xx2ae2f596a0fc42fb8ec1269514eafe18";
// api url list
var marketListUrl = "https://sandbox-apigw.koscom.co.kr/v2/market/stocks/{marketcode}/lists";
var waveletPricesUrl = "https://sandbox-apigw.koscom.co.kr/v1/wavelet/prices/{issuecode}";

// url 생성
function getMarketListUrl(marketcode){
	return marketListUrl.replace(/{marketcode}/g, encodeURIComponent(marketcode));
}

function getWaveletPricesUrl(issuecode){
	return waveletPricesUrl.replace(/{issuecode}/g, encodeURIComponent(issuecode));
}

// 종목 리스트 가져오기
function getMarketList(marketcode, func){
	$.ajax({
		url: getMarketListUrl(marketcode),
		type: "GET",
		beforeSend: function(xhr){
			xhr.setRequestHeader("apikey", apikey);
		},
		success: func
	});
}

// 종목 시세 가져오기
function getWaveletPrices(issuecode, func){
	$.ajax({
		url: getWaveletPricesUrl(issuecode),
		type: "GET",
		beforeSend: function(xhr){
			xhr.setRequestHeader("apikey", apikey);
		},
		success: func
	});
}


// 기본 호출
getMarketList("kospi",function(e){
	var tmpHtml = "";
	$.each(e.isuLists, function(idx){
		tmpHtml += '<li isuSrtCd="'+this.isuSrtCd+'" isuCd="'+this.isuCd+'">'+this.isuKorNm+'</li>';
	});
	$("#stocksList ul").html(tmpHtml);
});

// 이벤트 추가
$(document).on("click", "#stocksList li", function(){
	var issuecode = $(this).attr("isuSrtCd");
	getWaveletPrices(issuecode, function(e){
		var d = e.data[0];
		var name = d.name_ko;
		var open = d.price.open;
		var high = d.price.high;
		var low = d.price.low;
		var close = d.price.close;
		
		$("#waveletInfo td.name").text(name);
		$("#waveletInfo td.open").text(open);
		$("#waveletInfo td.high").text(high);
		$("#waveletInfo td.low").text(low);
		$("#waveletInfo td.close").text(close);
		
		$("#view>div").hide();
		$("#waveletInfo").show();
	});
});

// 뒤로가기
$(document).on("click", "#main", function(){
	$("#view>div").hide();
	$("#stocksList").show();
});
</script>
<style type="text/css">
#stocksList li { cursor: pointer; }
</style>
<title>3조</title>
</head>
<body>
<div id="main">main</div>

<div id="searchForm">
	<input type="text" name="sDate" value="" placeholder="시작기간" />
	<input type="text" name="eDate" value="" placeholder="종료기간" />
	<select name="cate1"></select>
</div>

<div id="view">
	<!-- 종목 리스트 -->
	<div id="stocksList">
		<ul>
		</ul>
	</div>
	<!-- //종목 리스트 -->
	
	<!-- 종목 시세 -->
	<div id="waveletInfo">
		<table>
		<tr>
			<th>종목명</th>
			<th>open</th>
			<th>high</th>
			<th>low</th>
			<th>close</th>
		</tr>
		<tr>
			<td class="name"></td>
			<td class="open"></td>
			<td class="high"></td>
			<td class="low"></td>
			<td class="close"></td>
		</tr>
		</table>
	</div>
	<!-- //종목 시세 -->
</div>
</body>
</html>