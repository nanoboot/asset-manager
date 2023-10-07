<%@ page session="false" %>
<%@page import="org.nanoboot.powerframework.time.moment.LocalDate"%>
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

<%@page import="org.nanoboot.assetmanager.persistence.api.AssetRepo"%>
<%@page import="org.nanoboot.assetmanager.entity.Asset"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.commons.fileupload.FileUploadException"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.io.output.*"%>
<%@page import="org.nanoboot.powerframework.time.moment.LocalDate"%>
<%@page import="org.nanoboot.powerframework.time.moment.LocalDateTime"%>
<%@page import="org.nanoboot.powerframework.time.moment.UniversalDateTime"%>
<%@page import="org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils"%>


<!DOCTYPE>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Asset Manager - Add asset</title>
        <link rel="stylesheet" type="text/css" href="styles/asset-manager.css">
        <link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
    </head>

    <body>

        <a href="index.jsp" id="main_title">Asset Manager</a></span>

    <span class="nav"><a href="index.jsp">Home</a>
        >> <a href="assets.jsp">Assets</a>
        >> <a href="create_asset.jsp" class="nav_a_current">Add Asset</a></span>

    <%
        if (org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.cannotUpdate(request)) {
            out.println("Access forbidden");
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>
    
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


    <%
        String param_name = request.getParameter("name");
        boolean formToBeProcessed = param_name != null && !param_name.isEmpty();
    %>

    <% if (!formToBeProcessed) { %>
    <form action="create_asset.jsp" method="get">
        <table>

            <tr>
                <td><label for="path1">Path 1:</label></td>
                <td><input type="text" name="path1" value=""></td>
            </tr>
            <tr>
                <td><label for="path2">Path 2:</label></td>
                <td><input type="text" name="path2" value=""></td>
            </tr>
            <tr>
                <td><label for="path2">Path 3:</label></td>
                <td><input type="text" name="path3" value=""></td>
            </tr>
            <tr>
                <td><label for="path2">Path 4:</label></td>
                <td><input type="text" name="path4" value=""></td>
            </tr>
            <tr>
                <td><label for="name">Name <b style="color:red;font-size:130%;">*</b>:</label></td>
                <td><input type="text" name="name" value=""></td>
            </tr>
            <tr>
                <td><label for="alias">Alias:</label></td>
                <td><input type="text" name="alias" value=""></td>
            </tr>
            <tr>
                <td><label for="since">Since:</label></td>
                <td><input type="text" name="since" value=""></td>
            </tr>
            <tr>
                <td><label for="priceValue">Price Value:</label></td>
                <td><input type="text" name="priceValue" value=""></td>
            </tr>
            <tr>
                <td><label for="priceCurrency">Price Currency:</label></td>
                <td><input type="text" name="priceCurrency" value=""></td>
            </tr>
            <tr>
                <td><label for="note">Note:</label></td>
                <td><input type="text" name="note" value=""></td>
            </tr>
            <tr>
                <td><label for="group">Group:</label></td>
                <td><input type="text" name="group" value=""></td>
            </tr>

            <tr>
                <td><a href="assets.jsp" style="font-size:130%;background:#dddddd;border:2px solid #bbbbbb;padding:2px;text-decoration:none;">Cancel</a></td>
                <td style="text-align:right;"><input type="submit" value="Add"></td>
            </tr>
        </table>
        <b style="color:red;font-size:200%;margin-left:20px;">*</b> ...mandatory


    </form>

    <% } else { %>







    <%
        String param_path1 = request.getParameter("path1");
        String param_path2 = request.getParameter("path2");
        String param_path3 = request.getParameter("path3");
        String param_path4 = request.getParameter("path4");

        String param_alias = request.getParameter("alias");
        String param_since = request.getParameter("since");
        String param_priceValue = request.getParameter("priceValue");
        String param_priceCurrency = request.getParameter("priceCurrency");
        
        String param_note = request.getParameter("note");
        String param_group = request.getParameter("group");
        //

        LocalDateTime addedOn = (new LocalDateTime(UniversalDateTime.now().toString()));
        //
        Asset newAsset = new Asset(
                Integer.valueOf(0),
                param_path1,
                param_path2,
                param_path3,
                param_path4,
                
                param_name,
                param_alias,
                param_since == null || param_since.isEmpty() ? null : new LocalDate(param_since),
                param_priceValue == null || param_priceValue.isEmpty()  ? null : Asset.convertPriceStringToPriceLong(param_priceValue),
                param_priceCurrency,
                
                param_note,
                param_group,
                addedOn);

        int numberOfNewAsset = assetRepo.create(newAsset);

        newAsset.setNumber(numberOfNewAsset);

    %>


    <p style="margin-left:20px;font-size:130%;">Created new asset with number <%=newAsset.getNumber()%>:<br><br>
        <a href="read_asset.jsp?number=<%=newAsset.getNumber()%>"><%=newAsset.getName()%></a>

    </p>






    <% }%>

    <div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>
    
</body>
</html>
