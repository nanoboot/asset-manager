<%@page import="org.nanoboot.powerframework.time.moment.LocalDate"%>
<%@page import="org.nanoboot.assetmanager.web.misc.utils.Utils"%>
<%@page import="org.nanoboot.assetmanager.persistence.api.AssetRepo"%>
<%@page import="org.nanoboot.assetmanager.entity.Asset"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.context.ApplicationContext"%>

<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.commons.fileupload.FileUploadException"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.io.output.*"%>

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
        <title>Update asset - Asset Manager</title>
        <link rel="stylesheet" type="text/css" href="styles/asset-manager.css">
        <link rel="icon" type="image/x-icon" href="favicon.ico" sizes="32x32">
    </head>

    <body>

        <a href="index.jsp" id="main_title">Asset Manager</a></span>


    <%
        String number = request.getParameter("number");
        if (number == null || number.isEmpty()) {
    %><span style="font-weight:bold;color:red;" class="margin_left_and_big_font">Error: Parameter "number" is required</span>

    <%
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>

    <span class="nav"><a href="index.jsp">Home</a>
        >> <a href="assets.jsp">Assets</a>
        >> <a href="read_asset.jsp?number=<%=number%>">Read</a>
        <a href="update_asset.jsp?number=<%=number%>" class="nav_a_current">Update</a>
        <a href="upload_asset_image.jsp?number=<%=number%>">Upload image</a>
    </span>

    <%
        if (org.nanoboot.assetmanager.web.misc.utils.Utils.cannotRead(request)) {
            out.println("Access forbidden");
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>
    
    <%
        if (org.nanoboot.assetmanager.web.misc.utils.Utils.cannotUpdate(request)) {
            out.println("Access forbidden");
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>
    <%
        ApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        AssetRepo assetRepo = context.getBean("assetRepoImpl", AssetRepo.class);
        Asset asset = assetRepo.read(Integer.valueOf(number));

        if (asset == null) {
    %><span style="font-weight:bold;color:red;" class="margin_left_and_big_font">Error: Asset with number <%=number%> was not found.</span>

    <%
            throw new jakarta.servlet.jsp.SkipPageException();
        }
        String param_name = request.getParameter("name");
        boolean formToBeProcessed = param_name != null && !param_name.isEmpty();
    %>

    <% if (!formToBeProcessed) {%>
    <form action="update_asset.jsp" method="get">
        <table>
            <tr>
                <td><label for="number">Number <b style="color:red;font-size:130%;">*</b>:</label></td>
                <td><input type="text" name="number" value="<%=number%>" readonly style="background:#dddddd;"></td>
            </tr>
            <tr>
                <td><label for="path1">Path 1:</label></td>
                <td><input type="text" name="path1" value="<%=asset.getPath1() == null ? "" : asset.getPath1()%>"></td>
            </tr>
            <tr>
                <td><label for="path2">Path 2:</label></td>
                <td><input type="text" name="path2" value="<%=asset.getPath2() == null ? "" : asset.getPath2()%>"></td>
            </tr>
            <tr>
                <td><label for="path3">Path 3:</label></td>
                <td><input type="text" name="path3" value="<%=asset.getPath3() == null ? "" : asset.getPath3()%>"></td>
            </tr>
            <tr>
                <td><label for="path4">Path 4:</label></td>
                <td><input type="text" name="path4" value="<%=asset.getPath4() == null ? "" : asset.getPath4()%>"></td>
            </tr>
            <tr>
                <td><label for="name">Name <b style="color:red;font-size:130%;">*</b>:</label></td>
                <td><input type="text" name="name" value="<%=asset.getName()%>"></td>
            </tr>
            <tr>
                <td><label for="note">Alias</label></td>
                <td><input type="text" name="alias" value="<%=asset.getAlias() == null ? "" : asset.getAlias()%>"></td>
            </tr>
            <tr>
                <td><label for="since">Since</label></td>
                <td><input type="text" name="since" value="<%=asset.getSince() == null ? "" : asset.getSince()%>"></td>
            </tr>
            <tr>
                <td><label for="priceValue">Price value</label></td>
                <td><input type="text" name="priceValue" value="<%=asset.getPriceValue() == null ? "" : asset.getPrettyPrice(false)%>"></td>
            </tr>
            <tr>
                <td><label for="priceCurrency">Price currency</label></td>
                <td><input type="text" name="priceCurrency" value="<%=asset.getPriceCurrency() == null ? "" : asset.getPriceCurrency()%>"></td>
            </tr>
            <tr>
                <td><label for="note">Note</label></td>
                <td><input type="text" name="note" value="<%=asset.getNote() == null ? "" : asset.getNote()%>"></td>
            </tr>

         
            <tr>
                <td><label for="group">Group</label></td>
                <td><input type="text" name="group" value="<%=asset.getGroup() == null ? "" : asset.getGroup()%>"></td>
            </tr>

            <tr>
                <td><a href="assets.jsp" style="font-size:130%;background:#dddddd;border:2px solid #bbbbbb;padding:2px;text-decoration:none;">Cancel</a></td>
                <td style="text-align:right;"><input type="submit" value="Update"></td>
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
       
        //
        //
        Asset updatedAsset = new Asset(
                Integer.valueOf(number),
                param_path1,
                param_path2,
                param_path3,
                param_path4,
                
                param_name,
                param_alias,
                param_since == null || param_since.isEmpty() ? null : new LocalDate(param_since),
                param_priceValue == null || param_priceValue.isBlank() ? null : Asset.convertPriceStringToPriceLong(param_priceValue),
                param_priceCurrency,
                
                param_note,
                param_group,
                null);

        assetRepo.update(updatedAsset);


    %>


    <script>
        function redirectToRead() {
            window.location.href = 'read_asset.jsp?number=<%=number%>'
        }
        redirectToRead();
    </script>
    <!--
        <p style="margin-left:20px;font-size:130%;">Updated asset with number <%=updatedAsset.getNumber()%>:<br><br>
            <a href="read_asset.jsp?number=<%=updatedAsset.getNumber()%>"><%=updatedAsset.getName()%></a>
    
        </p>
    -->




    <% }%>

    <div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>
</body>
</html>
