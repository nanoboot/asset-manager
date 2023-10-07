<%@page import="java.io.IOException"%>
<%@page import="java.util.Base64"%>
<%@page import="java.nio.file.Files"%>
<%@page import="java.io.File"%>
<%@page import="org.nanoboot.assetmanager.entity.Asset"%>
<%@page import="org.nanoboot.assetmanager.persistence.api.AssetRepo"%>
<%@page import="org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils"%>
<%@page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<!DOCTYPE>
<%@ page session="false" %>

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


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
    <head>
        <title>Read website - Asset Manager</title>
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
        >> <a href="read_asset.jsp?number=<%=number%>" class="nav_a_current">Read</a>

        <% boolean canUpdate = org.nanoboot.octagon.jakarta.utils.OctagonJakartaUtils.canUpdate(request); %>
        <% if(canUpdate) { %>
        <a href="update_asset.jsp?number=<%=number%>">Update</a>
        <a href="upload_asset_image.jsp?number=<%=number%>">Upload image</a>
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
        Asset asset = assetRepo.read(Integer.valueOf(number));

        if (asset == null) {
    %><span style="font-weight:bold;color:red;" class="margin_left_and_big_font">Error: Asset with number <%=number%> was not found.</span>

    <%
            throw new jakarta.servlet.jsp.SkipPageException();
        }
    %>
    <style>
        th{
            text-align:left;
            background:#cccccc;
        }
    </style>
    <p class="margin_left_and_big_font">


        <a href="read_asset.jsp?number=<%=asset.getNumber() - 1%>" class="button">Previous</a>
        <a href="read_asset.jsp?number=<%=asset.getNumber() + 1%>" class="button">Next</a>
    </p>
    <script>
        function redirectToUpdate() {


        <% if(canUpdate) { %>
            window.location.href = 'update_asset.jsp?number=<%=number%>'
        <% } %>


        }

    </script>  
    <table ondblclick = "redirectToUpdate()">
        <tr>
            <th>Number</th><td><%=asset.getNumber()%></td>

            <%

                File file = new File(System.getProperty("asset-manager.confpath") + "/" + "assetsImages/" + asset.getNumber() + ".jpg");
                System.err.println("file=" + file.getAbsolutePath());
                if (file.exists()) {
                    String imageBase64Encoded = null;
                    try {
                        byte[] fileContent = Files.readAllBytes(file.toPath());
                        imageBase64Encoded = Base64.getEncoder().encodeToString(fileContent);
            %><td rowspan="11"><img src="data:image/jpg;base64, <%=imageBase64Encoded%>" alt="screenshot" style="max-height:600px;"/></td><%
                } catch (IOException e) {
                    log("Could not read file " + file, e);
                }
}

            %>



        </tr>
        <tr><th>Path 1</th><td><%=OctagonJakartaUtils.formatToHtml(asset.getPath1())%></td></tr>
        <tr><th>Path 2</th><td><%=OctagonJakartaUtils.formatToHtml(asset.getPath2())%></td></tr>
        <tr><th>Path 3</th><td><%=OctagonJakartaUtils.formatToHtml(asset.getPath3())%></td></tr>
        <tr><th>Path 4</th><td><%=OctagonJakartaUtils.formatToHtml(asset.getPath4())%></td></tr>
        
        <tr><th>Name</th><td><%=asset.getName()%></td></tr>
        <tr><th>Alias</th><td><%=OctagonJakartaUtils.formatToHtml(asset.getAlias())%></td></tr>
        <tr><th>Since</th><td><%=OctagonJakartaUtils.formatToHtml(asset.getSince())%></td></tr>
        <tr><th>Price</th><td><%=OctagonJakartaUtils.formatToHtml(asset.getPrettyPrice())%></td></tr>
        
        <tr><th>Note</th><td><%=OctagonJakartaUtils.formatToHtml(asset.getNote())%></td></tr>
        <tr><th>Group</th><td><%=OctagonJakartaUtils.formatToHtml(asset.getGroup())%></td></tr>
        <tr><th>Added on</th><td><%=OctagonJakartaUtils.formatToHtml(asset.getAddedOn())%></td></tr>
        
    </table>


    <div id="footer">Content available under a <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License.">Creative Commons Attribution-ShareAlike 4.0 International License</a> <a href="http://creativecommons.org/licenses/by-sa/4.0/" target="_blank" title="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License."><img alt="Content available under a Creative Commons Attribution-ShareAlike 4.0 International License." style="border-width:0" src="images/creative_commons_attribution_share_alike_4.0_international_licence_88x31.png" /></a></div>

</body>
</html>
