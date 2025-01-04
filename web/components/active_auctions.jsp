<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>

<%
    // Fetch auctions passed from the servlet
    List<Map<String, Object>> auctions = (List<Map<String, Object>>) request.getAttribute("auctions");
%>     

<section class="p-6 mx-3">
        <h1 class="text-2xl font-semibold mx-5 mb-6">Active Auctions</h1>
        <div class="flex itmes-center gap-4">
        <div class="flex items-center justify-between mb-2">
            <button id="scrollLeft" class="bg-gray-600 font=bold text-white px-3 py-2 text-2xl rounded-full hover:bg-gray-500 transition">←</button>
        </div>
        <div class="slider">
            <div class="auction-container gap-4 flex">
                <% 
                    if (auctions != null && !auctions.isEmpty()) {
                        for (Map<String, Object> auction : auctions) {
                %>
                    <div class="w-[300px] bg-gray-800 p-2 rounded-xl shadow-lg hover:shadow-xl transition-all duration-300">
                        <div class="relative">
                             <a href="auctionDetailServlet?id=<%= auction.get("auctionId") %>">
                                <img src="<%= auction.get("itemImg") %>" alt="<%= auction.get("itemName") %>" class="w-full h-44 object-cover rounded-xl">
                            </a>
                            <div class="absolute top-2 right-2 bg-red-600 text-white text-sm px-3 py-1 rounded">
                                5h 20m
                            </div>
                        </div>
                        <div class="auction-details mt-3">
                            <h3 class="text-lg font-semibold text-white mb-1"><%= auction.get("itemName") %></h3>
                            <p class="text-gray-300 text-sm whitespace-wrap w-[98%] mb-4">
                                <%= auction.get("description").toString().length() > 100 ? auction.get("description").toString().substring(0, 80) + "..." : auction.get("description") %>
                            </p>
                            <div class="flex justify-between items-center text-sm text-gray-400 mb-3">
                                <div class="starting-bid">
                                    <span class="font-medium text-white">Starting Bid:</span>
                                    <span class="text-lg text-green-400">$<%= auction.get("startingPrice") %></span>
                                </div>
                            </div>
                            <div class="flex items-center gap-3">
                                <a href="auctionDetailServlet?id=<%= auction.get("auctionId") %>" class="w-fit text-sm px-4 py-2 rounded-lg bg-gray-900 hover:bg-gray-600 transition duration-200 font-semibold text-white">
                                    View Auction
                                </a>
                                <a href="auctionDetailServlet?id=<%= auction.get("auctionId") %>" class="w-fit text-sm px-4 py-1 rounded-lg hover:opacity-65 border border-gray-300 transition duration-200 font-semibold text-white">
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
        </div>
            <div class="flex items-center">
               <button id="scrollRight" class="bg-gray-600 font-bold text-white px-3 py-2 text-2xl rounded-full hover:bg-gray-500 transition">→</button>

            </div>
           </div>
            <script>
        const scrollLeftBtn = document.getElementById('scrollLeft');
        const scrollRightBtn = document.getElementById('scrollRight');
        const slider = document.querySelector('.slider');

        scrollLeftBtn.addEventListener('click', () => {
            slider.scrollBy({
                top: 0,
                left: -slider.clientWidth / 3, // Scroll left by one-third of the slider width
                behavior: 'smooth'
            });
        });

        scrollRightBtn.addEventListener('click', () => {
            slider.scrollBy({
                top: 0,
                left: slider.clientWidth / 3, // Scroll right by one-third of the slider width
                behavior: 'smooth'
            });
        });
    </script>
    </section>

 