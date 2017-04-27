<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
* { margin: 0px; padding: 0px; }
li { list-style-type: none; }
#topWrap {
    padding: 10px;
    font-size: 20pt;
    background-color: #f39c11;
    color: #fff;
    text-align: center;
}
#searchForm li { margin: 10px; text-align: center; }
#searchForm li span {
    width: 20%;
    display: inline-block;
    padding: 10px;
    background-color: #f39c11;
    border-radius: 10px;
    border: #847b7b;
    text-align: center;
}
#searchForm li input {
    width: 20%;
    display: inline-block;
    padding: 10px 5px;
    text-align: center;
}
#searchForm li input.edate {
	margin-left: 10px;
}
#searchForm li select { width: 50%; padding: 10px 15px;}
#view { margin: 20px; }
#stocksList li {
    padding: 10px 0px;
    text-align: center;
    overflow: hidden;
}
#stocksList li.fRow { background-color: #eaeaea; }
#stocksList li .no { float: left; width: 20%; }
#stocksList li .isuKor { float: left; width: 50%; }
#stocksList li .udp { float: left; width: 25%; }
</style>
<title>3조</title>
</head>
<body>

<div id="topWrap">
	<span>종목 조회</span>
</div>

<div id="searchForm">
	<ul>
		<li>
			<span>검색기간</span>
			<input type="text" name="sDate" value="" placeholder="시작기간" />
			<input type="text" name="eDate" value="" placeholder="종료기간" />
		</li>
		<li>
			<span>종목분류</span>
			<select name="cate1">
			<option>aaaaaa</option>
			</select>
		</li>
	</ul>
</div>

<div id="view">
	<!-- 종목 리스트 -->
	<div id="stocksList">
		<ul>
			<li class="fRow">
				<span class="no">No.</span>
				<span class="isuKor">종목명</span>
				<span class="udp">등락율</span>
			</li>
			<c:forEach begin="0" end="${marketList.length() -1}" var="index">
			<li>
				<span class="no">${index+1 } </span>
				<span class="isuKor">${marketList.getJSONObject(index).getString("isuKorNm")}</span>
				<span class="udp">-</span>
			</li>
			</c:forEach>
		</ul>
	</div>
	<!-- //종목 리스트 -->
</div>
</body>
</html>