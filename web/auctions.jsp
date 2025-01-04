<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String selectedCategory = request.getParameter("category");  // Fetch selected category from request
    String query = request.getParameter("query"); // Fetch search query
    
    // Fetch auctions passed from the servlet
    List<Map<String, Object>> auctions = (List<Map<String, Object>>) request.getAttribute("auctions");

    // Filter auctions based on the query if it exists
    if (query != null && !query.trim().isEmpty()) {
        auctions = auctions.stream()
                .filter(auction -> auction.get("itemName").toString().toLowerCase().contains(query.toLowerCase()))
                .collect(java.util.stream.Collectors.toList());
    }
%>

<%@ include file="/components/header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Auction Listings</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-900 text-gray-200">
    <!-- Header -->
    <div class="flex justify-center items-center gap-5 w-full">
        <div class="flex space-x-2 bg-gray-800 items-center mt-8 w-fit p-2 px-5 rounded-xl mb-6">
            <a href="auctionServlet?category=all" class="text-white hover:text-gray-400 transition-all duration-200 py-2 px-4 rounded-lg 
                    <%= selectedCategory != null && selectedCategory.equals("all") ? "bg-gray-600 border-2 border-gray-400" : "hover:bg-gray-600" %>">All</a>

                <!-- Category Links -->
                <a href="auctionServlet?category=electronics" class="text-white hover:text-gray-400 transition-all duration-200 py-1 px-2 rounded-lg 
                    <%= selectedCategory != null && selectedCategory.equals("electronics") ? "bg-gray-600 border-2 border-gray-400" : "hover:bg-gray-600" %>">Electronics</a>
                <a href="auctionServlet?category=house" class="text-white hover:text-gray-400 transition-all duration-200 py-1 px-2 rounded-lg 
                    <%= selectedCategory != null && selectedCategory.equals("house") ? "bg-gray-600 border-2 border-gray-400" : "hover:bg-gray-600" %>">House</a>
                <a href="auctionServlet?category=furniture" class="text-white hover:text-gray-400 transition-all duration-200 py-1 px-2 rounded-lg 
                    <%= selectedCategory != null && selectedCategory.equals("furniture") ? "bg-gray-600 border-2 border-gray-400" : "hover:bg-gray-600" %>">Furniture</a>
                <a href="auctionServlet?category=clothing" class="text-white hover:text-gray-400 transition-all duration-200 py-1 px-2 rounded-lg 
                    <%= selectedCategory != null && selectedCategory.equals("clothing") ? "bg-gray-600 border-2 border-gray-400" : "hover:bg-gray-600" %>">Clothing</a>
                <a href="auctionServlet?category=jewelry" class="text-white hover:text-gray-400 transition-all duration-200 py-1 px-2 rounded-lg 
                    <%= selectedCategory != null && selectedCategory.equals("jewelry") ? "bg-gray-600 border-2 border-gray-400" : "hover:bg-gray-600" %>">Jewelry</a>
                <a href="auctionServlet?category=books" class="text-white hover:text-gray-400 transition-all duration-200 py-1 px-2 rounded-lg 
                    <%= selectedCategory != null && selectedCategory.equals("books") ? "bg-gray-600 border-2 border-gray-400" : "hover:bg-gray-600" %>">Books</a>
                <a href="auctionServlet?category=vehicles" class="text-white hover:text-gray-400 transition-all duration-200 py-1 px-2 rounded-lg 
                    <%= selectedCategory != null && selectedCategory.equals("vehicles") ? "bg-gray-600 border-2 border-gray-400" : "hover:bg-gray-600" %>">Vehicles</a>
                <a href="auctionServlet?category=other" class="text-white hover:text-gray-400 transition-all duration-200 py-1 px-2 rounded-lg 
                    <%= selectedCategory != null && selectedCategory.equals("other") ? "bg-gray-600 border-2 border-gray-400" : "hover:bg-gray-600" %>">Other</a>
           
       
        </div>
        
        <!-- Search Form -->
        <form action="auctionServlet" method="get" class="mt-4 flex itmes-center gap-2 rounded-lg bg-gray-800">
            <input type="text" name="query" placeholder="Search by item name..." class="px-4 py-3 bg-gray-800 rounded-lg oultline-none  text-white" value="<%= query != null ? query : "" %>" />
            <button type="submit" class="text-white px-4 py-2 rounded-lg hover:bg-gray-600"><img class="h-6" src="assets/images/ser.png" alt="alt"/></button>
        </form>
    </div>

    <!-- Main Content -->
    <main class="p-6 mx-20">
     <h1 class="text-2xl font-semibold mb-6">
    <%
        if (query != null && !query.trim().isEmpty()) {
    %>
        Search results for "<%= query %>"
    <%
        } else {
            String category = selectedCategory != null && !selectedCategory.isEmpty() 
                                ? selectedCategory.substring(0, 1).toUpperCase() + selectedCategory.substring(1) 
                                : "All";
            out.print(category + " Auctions");
        }
    %>
</h1>


        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <% 
                if (auctions != null && !auctions.isEmpty()) {
                    for (Map<String, Object> auction : auctions) {
            %>
                <div class="auction-item bg-gray-800 p-3 rounded-lg shadow-lg hover:shadow-xl transition-all duration-300">
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
                            <div class="flex items-center gap-3">
                                 <a href="auctionDetailServlet?id=<%= auction.get("auctionId") %>" class="w-fit px-4 py-2 rounded-lg bg-gray-900 hover:bg-gray-600 transition duration-200 font-semibold text-white">
                                    View Auction
                                 </a>
                                <a href="auctionDetailServlet?id=<%= auction.get("auctionId") %>" class="w-fit px-4 py-1 rounded-lg bg-blue-600 hover:bg-blue-400 transition duration-200 font-semibold text-white">
                                    Place Your Bid
                                  </a>
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

       
    </main>

    <!-- Footer -->
    <%@ include file="/components/footer.jsp" %>

    <!-- Mobile Menu Script -->
    <script>
        const menuToggle = document.getElementById("menu-toggle");
        const mobileMenu = document.getElementById("mobile-menu");

        menuToggle.addEventListener("click", () => {
            mobileMenu.classList.toggle("hidden");
        });
    </script>
</body>
</html>
