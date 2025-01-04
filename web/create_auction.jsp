<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if session is not active
    }
%>
<%@ include file="/components/header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Auction</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-900 font-sans">

   <div class="max-w-4xl mx-auto  mt-8 mb-16 p-8 bg-gray-900">
    <h2 class="text-2xl font-semibold text-gray-100 mb-6">Create your Auction</h2>

    <form action="CreateAuctionServlet" method="POST" class="grid grid-cols-1 md:grid-cols-2 gap-6">

        <!-- Item Name -->
        <div class="mb-2">
            <label for="item_name" class="block text-gray-300">Item Name</label>
            <input type="text" id="item_name" name="item_name" class="w-full p-3 mt-2 border rounded-md border-gray-600 bg-gray-700 text-gray-100" required>
        </div>

        <div class="mb-2">
            <label for="item_img" class="block text-gray-300">Item Image URL</label>
            <input type="text" id="item_img" name="item_img" class="w-full p-3 mt-2 border rounded-md border-gray-600 bg-gray-700 text-gray-100" required>
        </div>

        <!-- Description -->
        <div class="mb-2 col-span-2">
            <label for="description" class="block text-gray-300">Description</label>
            <textarea id="description" name="description" rows="4" class="w-full p-3 mt-2 border rounded-md border-gray-600 bg-gray-700 text-gray-100" required></textarea>
        </div>

        <!-- Starting Price -->
        <div class="mb-2">
            <label for="starting_price" class="block text-gray-300">Starting Price ($)</label>
            <input type="number" id="starting_price" name="starting_price" class="w-full p-3 mt-2 border rounded-md border-gray-600 bg-gray-700 text-gray-100" step="0.01" required>
        </div>

        <!-- Current Bid -->
        <div class="mb-2">
            <label for="current_bid" class="block text-gray-300">Current Bid ($)</label>
            <input type="number" id="current_bid" name="current_bid" class="w-full p-3 mt-2 border rounded-md border-gray-600 bg-gray-700 text-gray-100" step="0.01" value="0.00">
        </div>

        <!-- Start Time -->
        <div class="mb-2">
            <label for="start_time" class="block text-gray-300">Start Time</label>
            <input type="datetime-local" id="start_time" name="start_time" class="w-full p-3 mt-2 border rounded-md border-gray-600 bg-gray-700 text-gray-100" required>
        </div>

        <!-- End Time -->
        <div class="mb-2">
            <label for="end_time" class="block text-gray-300">End Time</label>
            <input type="datetime-local" id="end_time" name="end_time" class="w-full p-3 mt-2 border rounded-md border-gray-600 bg-gray-700 text-gray-100" required>
        </div>

        <!-- Status -->
        
        <div class=" ">
            <label for="status" class="block text-gray-300">Status</label>
            <select id="status" name="status" class="w-full p-3 mt-2 border rounded-md border-gray-600 bg-gray-700 text-gray-100">
                <option value="waiting">Waiting</option>
                <option value="active">Active</option>
                <option value="completed">Completed</option>
                <option value="canceled">Canceled</option>
            </select>
        </div>

        <!-- Item Type -->
        <div class=" ">
            <label for="item_type" class="block text-gray-300">Item Type</label>
            <select id="item_type" name="item_type" class="w-full p-3 mt-2 border rounded-md border-gray-600 bg-gray-700 text-gray-100">
                <option value="electronics">Electronics</option>
                <option value="house">House</option>
                <option value="furniture">Furniture</option>
                <option value="clothing">Clothing</option>
                <option value="jewelry">Jewelry</option>
                <option value="books">Books</option>
                <option value="vehicles">Vehicles</option>
                <option value="other">Other</option>
            </select>
        </div>

        <c:if test="${not empty errorMessage}">
            <p class="error">${errorMessage}</p>
        </c:if>

        <!-- Submit Button -->
        <div class="flex justify-center mt-5 col-span-2">
            <button type="submit" class="w-full py-3 bg-blue-600 text-white font-semibold rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-300">
                Create Auction
            </button>
        </div>
    </form>
</div>

<%@ include file="/components/footer.jsp" %>

</body>
</html>
