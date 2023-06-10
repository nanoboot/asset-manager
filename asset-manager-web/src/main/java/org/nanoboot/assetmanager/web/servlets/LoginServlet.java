///////////////////////////////////////////////////////////////////////////////////////////////
// Asset Manager.
// Copyright (C) 2023-2023 the original author or authors.
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; version 2
// of the License only.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
///////////////////////////////////////////////////////////////////////////////////////////////

package org.nanoboot.assetmanager.web.servlets;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.Properties;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(
        name = "LoginServlet",
        urlPatterns = "/LoginServlet"
)
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {

        String returnedUser = request.getParameter("user");
        String returnedPassword = request.getParameter("password");

        String expectedUser = "";
        String expectedPassword = "";

        String csaConfPath = System.getProperty("asset-manager.confpath");
        if (csaConfPath == null || csaConfPath.isEmpty()) {
            String msg = "csa configuration is broken : " + "asset-manager.confpath=" + csaConfPath;
            returnError(response, request, msg);
            return;
        }
        File csaProperties = new File(csaConfPath + "/asset-manager.properties");

        String authentication = "";
        try ( InputStream input = new FileInputStream(csaProperties.getAbsolutePath())) {

            Properties properties = new Properties();
            properties.load(input);
            authentication = properties.getProperty("authentication");

        } catch (IOException ex) {
            ex.printStackTrace();
            returnError(response, request, "Loading csa properties failed.");
            return;
        }
        
        if (authentication != null && !authentication.isBlank()) {
            String[] authenticationArray = authentication.split("/");
            if (authenticationArray.length != 2) {
                returnError(response, request, "csa configuration is broken (array.length != 2). Contact csa administrator.");
                return;
            }
            expectedUser = authenticationArray[0];
            expectedPassword = authenticationArray[1];
        }

      

        if (expectedUser.equals(returnedUser) && expectedPassword.equals(returnedPassword)) {
            HttpSession oldSession = request.getSession(false);
            //invalidate old session
            if (oldSession != null) {
                oldSession.invalidate();
            }
            //new session
            HttpSession newSession = request.getSession(true);

            System.out.println("Created new session " + newSession.toString());
            newSession.setAttribute("canUpdate", "true");
            
            System.err.println("canUpdate&& = " + newSession.getAttribute("canUpdate"));
            newSession.setMaxInactiveInterval(6 * 60 * 60);

            response.sendRedirect("index.jsp");
        } else {
            returnError(response, request, "Either user or password is wrong.");
        }
    }

    private void returnError(HttpServletResponse response, HttpServletRequest request, String error) throws ServletException, IOException {
        RequestDispatcher rd = getServletContext().getRequestDispatcher("/login.html");

        PrintWriter out = response.getWriter();
        out.println("<font color=red>" + error + " </font>");
        rd.include(request, response);
    }

}
