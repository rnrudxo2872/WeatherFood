<%@page import="java.net.URLDecoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String title = request.getParameter("title");
String name = (String)session.getAttribute("id");
String context = request.getContextPath();
%>

<a href="main.jsp"><img class="headerLogo" src="<%=context %>/logos/weatherFood.png"></img></a>
<div class="header-container">
<div>
<h1 class="pageTitle"><%=URLDecoder.decode(title,"utf-8") %></h1>
<div class="logForm">
<%if(name == null){
%>
<a href="<%=context %>/login.use">로그인</a>
<%}else{%>
<span><%=name %>님</span>
<span><a href="<%=context %>/logout.use">로그아웃</a></span>
<span><a href="<%=context %>/update.use">회원 정보수정</a></span>
<%}%>
</div>
</div>
<%@include file="nav.jsp"%>
<jsp:include page="weatherParseTest.jsp"></jsp:include>
</div>