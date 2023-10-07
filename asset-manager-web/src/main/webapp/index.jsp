<!DOCTYPE>

<!--
 Asset Manager.
 Copyright (C) 2023-2023 the original author or authors.

 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; version 2
 of the License only.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
-->

<%@ page session="false" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
<title>Asset Manager</title>
<link rel="stylesheet" type="text/css" href="styles/asset-manager.css">
<link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
</head>
 
<body>

<a href="index.jsp" id="main_title">Asset Manager</a></span>

       <span class="nav"><a href="index.jsp" class="nav_a_current">Home</a>
        >> <a href="assets.jsp">Assets</a></span>


    <%
        if (org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.cannotRead(request)) {
            out.println("Access forbidden");
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>
    
    <% boolean canUpdate = org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.canUpdate(request); %>
<% if(canUpdate) { %>
<form action="<%=request.getContextPath()%>/LogoutServlet" method="post" style="display:inline;margin-left:20px;">
<input type="submit" value="Logout" >
</form>

<br>
<br>

<% } %>

<div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>

</body>
</html>
