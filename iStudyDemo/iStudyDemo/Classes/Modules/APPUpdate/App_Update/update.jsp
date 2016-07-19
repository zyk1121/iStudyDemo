<%@page import="java.net.InetAddress"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    <title>iosandroid choose</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	
	<meta http-equiv="Content-Type" content="text/HTML; charset=utf-8">
	<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;" name="viewport" />

</head>
 <body>
    <%
    	//InetAddress localhost = InetAddress.getByName("");
    	String agent = request.getHeader("user-agent").toLowerCase();
    	String base = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort() + "/Leador_App_Update/update/";
    	if(agent != null) {
			if(agent.indexOf("android") > -1) {
    			response.sendRedirect(base  + "IshowchinaMap.apk");
    		} else if(agent.indexOf("iphone") > -1 || agent.contains("ipad")){
    			response.sendRedirect("itms-apps://itunes.apple.com/app/id461703208");
    		}    	
    	}
    	out.println("<a href='" + base + "CollectionData.apk'>android</a><br/>");
    	out.println("<a href='itms-apps://itunes.apple.com/app/id461703208'>iphone/ipad</a><br/>");
     %>
  </body>
</html>