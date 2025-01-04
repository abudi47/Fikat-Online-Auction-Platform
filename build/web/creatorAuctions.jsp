<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.util.List, java.util.Map" %>

<%
    // Fetch auctions passed from the servlet
    List<Map<String, Object>> auctions = (List<Map<String, Object>>) request.getAttribute("auctions");
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
<style>
   
.scroll {
  overflow: scroll; 
}

.scroll::-webkit-scrollbar {
  width: 8px;  
  height: 8px; 
}

.scroll::-webkit-scrollbar-thumb {
  background-color: black;
  border-radius: 4px;  
}

.scroll::-webkit-scrollbar-track {
  background-color: transparent; /* Makes the track background invisible */
}

/* Firefox scrollbar style */
.scroll {
  scrollbar-width: thin;
  scrollbar-color: black transparent; /* Thumb color and track color */
}

</style>
<body class="bg-gray-900 text-gray-100">

    <!-- Main Layout -->
    <div class="flex min-h-screen">

        <!-- Admin Panel (Sidebar) -->
        <nav class="w-72 h-[90vh] bg-gray-800 shadow-xl ml-2 mt-2 mb-2 rounded-xl  text-gray-200 p-6">
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
                    <a href="creatorAuctionsServlet" class="block px-4 py-2 rounded-lg text-sm font-medium bg-gray-900 border border-gray-300 hover:bg-gray-600 transition duration-300">My Auctions</a>
                </li>
                <li>
                    <a href="userBidsServlet" class="block px-4 py-2 rounded-lg text-sm font-medium bg-gray-700 hover:bg-gray-600 transition duration-300">My Bids</a>
                </li>
                
            </ul>
            <div>
                    <a href="logout.jsp" class="block px-4 py-2 rounded-lg text-sm font-medium bg-red-600 hover:bg-red-500 transition duration-300">Logout</a>
                </div>
            </div>
            
        </nav>
            
            <div class="scroll p-12 h-[90vh] overflow-scroll pt-8">
                <h1 class="text-2xl mb-6 font-bold">Your Active Auctions</h1>
            <div class="grid grid-cols-1  md:grid-cols-2 lg:grid-cols-3 gap-4">
            <% 
                if (auctions != null && !auctions.isEmpty()) {
                    for (Map<String, Object> auction : auctions) {
            %>
                <div class="auction-item bg-gray-800 p-3 pb-2 rounded-lg shadow-lg hover:shadow-xl transition-all duration-300">
                    <div class="relative">
                        <a href="auctionDetailServlet?id=<%= auction.get("auctionId") %>">
                         <img src="<%= auction.get("itemImg") %>" alt="<%= auction.get("itemName") %>" class="w-full h-64 object-cover rounded-xl">
                        </a>
                        <div class="absolute top-2 right-2 bg-red-600 text-white text-sm px-3 py-1 rounded">
                            5h 20m
                        </div>
                    </div>
                    <div class="auction-details mt-6">
                        <h3 class="text-lg font-semibold text-white mb-2"><%= auction.get("itemName") %></h3>
                        <p class="text-gray-300 text-sm whitespace-wrap w-[98%] mb-4">
                            <%= auction.get("description").toString().length() > 100 ? auction.get("description").toString().substring(0, 80) + "..." : auction.get("description") %>
                        </p>

                        <div class="flex justify-between items-center text-sm text-gray-400 mb-6">
                            <div class="starting-bid">
                                <span class="font-medium text-white">Starting Bid:</span>
                                <span class="text-lg text-green-400">$<%= auction.get("startingPrice") %></span>
                            </div>
                        </div>
                           
                       
                    </div>
                </div>
            <% 
                    }
                } else {
            %>
                <p>No active auctions available at the moment.</p>
            <% } %>
        </div>

            </div>
            
 
    </div>

   

</body>
</html>
