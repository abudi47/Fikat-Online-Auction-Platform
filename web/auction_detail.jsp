<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
%>
<%@ include file="/components/header.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Auction Details</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        // JavaScript function to format date into MM/DD/YYYY hh:mm AM/PM format
        function formatDate(dateStr) {
            const date = new Date(dateStr);
            const options = { 
                weekday: 'short', 
                year: 'numeric', 
                month: 'short', 
                day: 'numeric', 
                hour: '2-digit', 
                minute: '2-digit',
                hour12: true
            };
            return new Intl.DateTimeFormat('en-US', options).format(date);
        }

        // JavaScript function to determine auction status based on end time
        function getAuctionStatus(endTime) {
            const endDate = new Date(endTime);
            const now = new Date();

            if (now > endDate) {
                return "Auction Ended";
            } else {
                return "Auction Ongoing";
            }
        }

        // Wait for the DOM to be fully loaded before manipulating it
        window.onload = function() {
            // Get raw dates from the server-side JSP
            const startTime = "${auction.startTime}";
            const endTime = "${auction.endTime}";

            // Format the dates using JavaScript
            document.getElementById('start-time').innerText = formatDate(startTime);
            document.getElementById('end-time').innerText = formatDate(endTime);

            // Set auction status
            document.getElementById('auction-status').innerText = "${auction.status}";
        };
    </script>
</head>
<body class="bg-gray-900 text-gray-100">

    <div class="container my-8 mx-auto p-6">
        <c:choose>
            <!-- Check if auction data exists -->
            <c:when test="${not empty auction}">
                <div class="bg-gray-800 rounded-xl p-3 shadow-lg overflow-hidden grid grid-cols-1 md:grid-cols-2">
                    <!-- Image Section -->
                    <div class="relative">
                        <img src="${empty auction.itemImg ? 'default-image.jpg' : auction.itemImg}" 
                             alt="${auction.itemName}" 
                             class="w-full h-[70vh] rounded-lg object-cover">
                        <div class="absolute top-2 left-2 bg-gray-900 text-white px-2 py-1 rounded text-sm">Auction Status: ${auction.status}</div>
                    </div>

                    <!-- Details Section -->
                    <div class="p-8 space-y-6">
                        <h1 class="text-4xl font-bold text-gray-100 mb-4">${auction.itemName}</h1>
                        <p class="text-gray-400 mb-6">${auction.description}</p>
                        <div class="space-y-4">
                            <div class="flex justify-between items-center text-gray-300">
                                <span class="text-lg font-semibold">Starting Price:</span>
                                <span class="text-lg text-green-500 font-bold">$${auction.startingPrice}</span>
                            </div>
                            <div class="flex justify-between items-center text-gray-300">
                                <span class="text-lg font-semibold">Current Bid:</span>
                                <span class="text-lg text-blue-500 font-bold">$${auction.currentBid}</span>
                            </div>
                            <div class="flex justify-between items-center text-gray-300">
                                <span class="text-lg font-semibold">Start Time:</span>
                                <span class="text-lg" id="start-time">Loading...</span>
                            </div>
                            <div class="flex justify-between items-center text-gray-300">
                                <span class="text-lg font-semibold">End Time:</span>
                                <span class="text-lg" id="end-time">Loading...</span>
                            </div>
                            <!-- Display auction status -->
                            <div class="flex justify-between items-center text-gray-300">
                                <span class="text-lg font-semibold">Auction Status:</span>
                                <span class="text-lg text-red-500 font-bold" id="auction-status">Loading...</span>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>

           
        </c:choose>
    </div>
                                
    <%@ include file="/components/footer.jsp" %>


</body>
</html>
