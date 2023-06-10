<%@page import="org.nanoboot.assetmanager.web.misc.utils.Utils"%>
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
        
        
                
            <% boolean canUpdate = org.nanoboot.assetmanager.web.misc.utils.Utils.canUpdate(request); %>
<% if(canUpdate) { %>
>> <a href="create_asset.jsp">Add Asset</a>
<% } %>
        
    </span>

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
        final String EMPTY = "[empty]";
        String number = request.getParameter("number");
        String pageNumber = request.getParameter("pageNumber");
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

        <input type="submit" value="Filter" style="margin-left:20px;height:40px;">
        <br>
        <br>

        <input type="submit" name="PreviousNextPage" value="Previous page" style="margin-left:20px;height:40px;">
        <input type="submit" name="PreviousNextPage" value="Next page" style="margin-left:20px;height:40px;">
    </form>

    <%
        List<Asset> assets = assetRepo.list(
                pageNumberInt,
                10,
                number == null || number.isEmpty() ? null : Integer.valueOf(number)
                
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
                <%=Utils.formatToHtml(v.getPath1())%>
            </td>
            <td>
                <%=Utils.formatToHtml(v.getPath2())%>
            </td>
            <td>
                <%=Utils.formatToHtml(v.getPath3())%>
            </td>
            <td>
                <%=Utils.formatToHtml(v.getPath4())%>
            </td>
            
            
            <td>
                <%=v.getName()%>
            </td>
            
            <td>
                <%=Utils.formatToHtml(v.getAlias())%>
            </td>
            <td>
                <%=Utils.formatToHtml(v.getSince())%>
            </td>
            <td>
              <%=Utils.formatToHtml(v.getPrettyPrice())%> 
            </td>
            
            
            <td>
                <%=Utils.formatToHtml(v.getNote())%>
            </td>
            <td>
                <%=Utils.formatToHtml(v.getGroup())%>
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
