<%@page import="org.nanoboot.assetmanager.entity.Asset"%>
<%@page import="org.nanoboot.assetmanager.persistence.api.AssetRepo"%>
<%@page import="java.util.List"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.context.ApplicationContext"%>
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
        <title>List assets - Asset Manager</title>
        <link rel="stylesheet" type="text/css" href="styles/asset-manager.css">
        <link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
    </head>

    <body>

        <a href="index.jsp" id="main_title">Asset Manager</a></span>

    <span class="nav"><a href="index.jsp">Home</a>
        >> <a href="assets.jsp" class="nav_a_current">Assets</a>
        
        
                
            <% boolean canUpdate = org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.canUpdate(request); %>
<% if(canUpdate) { %>
>> <a href="create_asset.jsp">Add Asset</a>
<% } %>
        
    </span>

    <%
        if (org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.cannotRead(request)) {
            out.println("Access forbidden");
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>
    
    <%
        ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        AssetRepo assetRepo = context.getBean("assetRepoImpl", AssetRepo.class);
    %>


    <style>
        input[type="submit"] {
            padding-top: 15px !important;
            padding-left:10px;
            padding-right:10px;
            border:2px solid #888 !important;
            font-weight:bold;
        }
        input[type="checkbox"] {
            margin-right:20px;
        }
    </style>
    <%
        final String EMPTY = "<span style=\"color:silver;\">[empty]</span>";
        String number = request.getParameter("number");
        String path1 = request.getParameter("path1");
        String path2 = request.getParameter("path2");
        String path3 = request.getParameter("path3");
        String path4 = request.getParameter("path4");
        String pageNumber = request.getParameter("pageNumber");
        String pageSize = request.getParameter("pageSize");
        String previousNextPage = request.getParameter("PreviousNextPage");
                if (previousNextPage != null && !previousNextPage.isEmpty()) {
            if (previousNextPage.equals("Previous page")) {
                pageNumber = String.valueOf(Integer.valueOf(pageNumber) - 1);
            }
            if (previousNextPage.equals("Next page")) {
                pageNumber = String.valueOf(Integer.valueOf(pageNumber) + 1);
            }
        }
        int pageNumberInt = pageNumber == null || pageNumber.isEmpty() ? 1 : Integer.valueOf(pageNumber);

    %>


    <form action="assets.jsp" method="get">

        <label for="pageNumber">Page </label><input type="text" name="pageNumber" value="<%=pageNumberInt%>" size="4" style="margin-right:10px;">
        <label for="number">Number </label><input type="text" name="number" value="<%=number != null ? number : ""%>" size="5" style="margin-right:10px;">
        <label for="number">Path 1 </label><input type="text" name="path1" value="<%=path1 != null ? path1 : ""%>" style="margin-right:10px;">
        <label for="number">Path 2 </label><input type="text" name="path2" value="<%=path2 != null ? path2 : ""%>" style="margin-right:10px;">
        <label for="number">Path 3 </label><input type="text" name="path3" value="<%=path3 != null ? path3 : ""%>" style="margin-right:10px;">
        <label for="number">Path 4 </label><input type="text" name="path4" value="<%=path4 != null ? path4 : ""%>" style="margin-right:10px;">

        <input type="submit" value="Filter" style="margin-left:20px;height:40px;">
        <br>
        <br>

        <input type="submit" name="PreviousNextPage" value="Previous page" style="margin-left:20px;height:40px;">
        <input type="submit" name="PreviousNextPage" value="Next page" style="margin-left:20px;height:40px;">
    </form>

    <%
        List<Asset> assets = assetRepo.list(
                pageNumberInt,
                pageSize == null || pageSize.isBlank() ? 10 : Integer.valueOf(pageSize),
                number == null || number.isEmpty() ? null : Integer.valueOf(number),
                path1, path2, path3, path4
                
        );

        if (assets.isEmpty()) {

    %><span style="font-weight:bold;color:orange;" class="margin_left_and_big_font">Warning: Nothing found.</span>

    <%            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>

    <table>
        <tr>
            <th title="Number">#</th>
            <th style="width:100px;"></th>
            <th>Path 1</th>
            <th>Path 2</th>
            <th>Path 3</th>
            <th>Path 4</th>
            
            <th>Name</th>
            <th>Alias</th>
            <th>Since</th>
            <th>Price</th>
            
            <th>Note</th>
            <th>Group</th>
            <th>Added on</th>
        </tr>



        <style>

            tr td a img {
                border:2px solid grey;
                background:#dddddd;
                padding:4px;
                width:30%;
                height:30%;
            }
            tr td a img:hover {
                border:3px solid #888888;
                padding:3px;
            }
            tr td {
                padding-right:0;
            }
        </style>


        <%
            for (Asset v : assets) {
        %>
        <tr>
            <td><%=v.getNumber()%></td>
            <td>
                <a href="read_asset.jsp?number=<%=v.getNumber()%>"><img src="images/read.png" title="View" /></a>
                <% if(canUpdate) { %><a href="update_asset.jsp?number=<%=v.getNumber()%>"><img src="images/update.png" title="Update" /></a><%}%>
            </td>

            <td>
                <%=OctagonJakartaUtils.formatToHtml(v.getPath1())%>
            </td>
            <td>
                <%=OctagonJakartaUtils.formatToHtml(v.getPath2())%>
            </td>
            <td>
                <%=OctagonJakartaUtils.formatToHtml(v.getPath3())%>
            </td>
            <td>
                <%=OctagonJakartaUtils.formatToHtml(v.getPath4())%>
            </td>
            
            
            <td>
                <%=v.getName()%>
            </td>
            
            <td>
                <%=OctagonJakartaUtils.formatToHtml(v.getAlias())%>
            </td>
            <td>
                <%=OctagonJakartaUtils.formatToHtml(v.getSince())%>
            </td>
            <td>
              <%=OctagonJakartaUtils.formatToHtml(v.getPrettyPrice())%> 
            </td>
            
            
            <td>
                <%=OctagonJakartaUtils.formatToHtml(v.getNote())%>
            </td>
            <td>
                <%=OctagonJakartaUtils.formatToHtml(v.getGroup())%>
            </td>
            <td>
                <%=v.getAddedOn()== null ? EMPTY :v.getAddedOn().toString()%>
            </td>

        </tr>
        <%
            }
        %>

    </table>
        
        <div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>
</body>
</html>
