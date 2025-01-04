<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.util.List, java.util.Map" %>

<%
    List<Map<String, Object>> userBids = (List<Map<String, Object>>) request.getAttribute("userBids");
%>


<%
    // Retrieve user information from session
    String username = (String) session.getAttribute("username");
    String email = (String) session.getAttribute("email");

    // Redirect to login if the user is not logged in
    if (username == null || email == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<%@ include file="/components/header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-900 text-gray-100">

    <!-- Main Layout -->
    <div class="flex min-h-screen">

        <!-- Admin Panel (Sidebar) -->
    <nav class="w-48 h-[90vh] bg-gray-800 shadow-xl ml-2 mt-2 mb-2 rounded-xl text-gray-200 p-6">
            <div class="flex flex-col items-center">
                <!-- Profile Image -->
                <img src="https://via.placeholder.com/100" alt="Profile Picture" class="w-24 h-24 rounded-full mb-4">
                <h2 class="text-2xl font-semibold text-white mb-2"><%= username %></h2>
                <p class="text-sm text-gray-400 mb-6"><%= email %></p>
            </div>
            <div class="h-[50vh] flex flex-col justify-between">
                <ul class="space-y-4">
                    <li>
                        <a href="balanceServlet" class="block px-4 py-2 rounded-lg text-sm font-medium bg-gray-700 hover:bg-gray-600 transition duration-300">View Balance</a>
                    </li>
                    <li>
                        <a href="creatorAuctionsServlet" class="block px-4 py-2 rounded-lg text-sm font-medium bg-gray-700 hover:bg-gray-600 transition duration-300">My Auctions</a>
                    </li>
                    <li>
                        <a href="userBidsServlet" class="block px-4 py-2 rounded-lg text-sm font-medium bg-gray-900 border border-gray-300  hover:bg-gray-600 transition duration-300">My Bids</a>
                    </li>
                </ul>
                <div>
                    <a href="logout.jsp" class="block px-4 py-2 rounded-lg text-sm font-medium bg-red-600 hover:bg-red-500 transition duration-300">Logout</a>
                </div>
            </div>
        </nav>

        <section class="p-6 mx-3">
    <h1 class="text-2xl font-semibold mx-5 mb-6">Your Bids</h1>
    <div class="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        <% 
            if (userBids != null && !userBids.isEmpty()) {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm a"); // Example: Jan 04, 2025 10:45 AM
                for (Map<String, Object> bid : userBids) {
                    String formattedDate = sdf.format(bid.get("createdAt")); 
        %>
                <div class="w-[320px] bg-gray-800 p-4 rounded-xl shadow-lg">
                    <div class="flex gap-3">
                        <a class="w-[50%]" href="auctionDetailServlet?id=<%=bid.get("auctionId") %>">
                             <img src="<%= bid.get("itemImg") %>" alt="<%= bid.get("itemName") %>" class="w-full h-32 object-cover rounded-lg">
                        </a> 
                        <div>
                            <h3 class="text-sm mb-3 font-semibold text-white mt-3"><%= bid.get("itemName") %></h3>
                            <p class="text-sm text-gray-300">Your Bid:</p>
                            <p><span class="text-blue-600 text-lg">$<%= bid.get("bidAmount") %></span></p>
                        </div>
                    </div>
                    <p class="text-sm text-gray-200 mt-2">Bid Placed:  <%= formattedDate %></p>
                </div>
        <% 
                } 
            } else { 
        %>
            <p>No bids found. Participate in auctions to place your bids!</p>
        <% 
            } 
        %>
    </div>
</section>

       

    </div>

    <%@ include file="/components/footer.jsp" %>

</body>
</html>
