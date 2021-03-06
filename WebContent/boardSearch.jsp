<%@page import="com.weatherFood.board.searchBean"%>
<%@page import="com.weatherFood.board.boardDAO"%>
<%@page import="com.weatherFood.board.boardBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
String title ="게시글 검색";
%>
<title>FProject | <%=title %></title>
<%
request.setCharacterEncoding("utf-8");
String searchWord = request.getParameter("search");


if(searchWord == null || request.getParameter("type") == null){
	%>
	<script>
	alert("잘못된 경로입니다!");
	location.href = "./main";
	</script>
	<%
	return;
}

int searchType = Integer.parseInt(request.getParameter("type"));

//보여줄 게시판 개수
int pageSize;
if(request.getParameter("pageSize") == null)
	pageSize = 5;
else
	pageSize = Integer.parseInt(request.getParameter("pageSize"));

//현재페이지
String pageNum = request.getParameter("pageNum");
if(pageNum == null || pageNum.equals("null"))
	pageNum = "1";

int currentPage = Integer.parseInt(pageNum);

int startRow = (currentPage - 1) * pageSize + 1;
int endRow = currentPage * pageSize;

searchBean searchObj = new searchBean();
searchObj.setSearchWord(searchWord);
searchObj.setSearchType(searchType);

boardDAO bdao = new boardDAO();

System.out.println(searchObj);

//DB 글 개수
int cnt = bdao.searchBoardCnt(searchObj);
ArrayList<boardBean> bbs = bdao.searchBoard(searchObj, startRow, pageSize);
%>
<%@include file="partials/style.jsp" %>
</head>
<body>

<div class="basicFrame">
<div class="header">
<jsp:include page="partials/header.jsp" flush="true">
<jsp:param value='<%=URLEncoder.encode(title, "UTF-8") %>' name="title"/>
</jsp:include>
</div>
<div>
    <main class="board-container">
        <table class="board-container-boardList">
        
			<tr>
	            <th>게시글 번호</th>
	            <th>제목</th>
	            <th>작성자</th>
	            <th>작성 날짜</th>
        	</tr>
			<%
			for(int i = 0; i < bbs.size(); i++){
			boardBean curBoard = (boardBean)bbs.get(i);
			%>
			<tr>
	            <td><a href=""><%=curBoard.getNum() %></a></td>
	            <td><a href="./shareBoard/content?num=<%=curBoard.getNum()%>&pageNum=<%=pageNum%>"><%=curBoard.getTitle() %></a></td>
	            <td><a href=""><%=curBoard.getUser_name()%></a></td>
	            <td><a href=""><%=curBoard.getDate() %></a></td>
        	</tr>
			<%} %>       
        </table>
        <div class="board-container-footer">
            <div class="board-container-footer__pagelink">
            <%
            //게시글이 있다면
            if(cnt != 0){
            	//페이지 갯수
            	int pageCount = cnt/pageSize + (cnt%pageSize == 0 ? 0 : 1);
            	
            	//한 페이지에서 보여줄 페이지 블럭 수
            	int pageBlock = 5;
            	
            	//한 블럭의 시작 페이지
            	int startPage = ((currentPage - 1)/pageBlock) * pageBlock + 1;
            	
            	//블럭 끝 페이지
            	int endPage = startPage + pageBlock - 1;
            	
            	if(endPage > pageCount){
            		endPage = pageCount;
            	}
            	
            	//이전
            	if(startPage > pageBlock){
					%>
					<a href="boardSearch?pageNum=<%=startPage - 1%>&pageSize=<%=pageSize%>&type=<%=searchObj.getSearchType() %>&search=<%=searchObj.getSearchWord() %>">이전</a>
					<%
            	}
            	
            	for(int i = startPage; i<= endPage; i++){
            		%>
            		<a <%if(i == currentPage){%>class="curPageNum"<%} else{%>href="boardSearch?pageNum=<%=i%>&pageSize=<%=pageSize%>&type=<%=searchObj.getSearchType() %>&search=<%=searchObj.getSearchWord() %>"<%}%>><%=i %></a>
            		<%
            	}
            	
            	if(endPage < pageCount){
            		%>
            		<a href="boardSearch?pageNum=<%=endPage + 1%>&pageSize=<%=pageSize%>&type=<%=searchObj.getSearchType() %>&search=<%=searchObj.getSearchWord() %>">다음</a>
            		<%
            	}
            }
			%>
            </div>
        </div>
    </main>

            <form class="board-container-footer__search" action="boardSearch" method="get"></form>
            
           	<%if(session.getAttribute("id") != null) {%>
           	<a class="board-container-footer__insertBoard" href="shareBoard/insertBoard">글쓰기</a>
           	<%} %>
    <div>
	<span>게시판 출력개수</span>
	<select class="pageBlockSelector">
	    <option value="5">5개</option>
	    <option value="10">10개</option>
	    <option value="15">15개</option>
	    <option value="20">20개</option>
	</select>
	</div>
    </div>
<div>
<%@include file="partials/footer.jsp" %>
</div> 
</div>
<script>document.querySelector('.pageBlockSelector').querySelectorAll('option')[<%=pageSize/5%>-1].setAttribute("selected","selected");</script>
<script type="module" src="js/changePageBlock.js"></script>
</body>
</html>