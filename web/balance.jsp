<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%@ page import="java.text.SimpleDateFormat, java.util.Date" %>
<%@ page import="java.util.List, java.util.Map" %>

<%
    // Retrieve user information from session
    String username = (String) session.getAttribute("username");
    String email = (String) session.getAttribute("email");

    // Redirect to login if the user is not logged in
    if (username == null || email == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Fetch balance amount and transactions passed from the servlet
    Double balanceAmount = (Double) request.getAttribute("balanceAmount");
     String SuccsusMessage = (String) request.getAttribute("successMessage");

    List<Map<String, Object>> transactions = (List<Map<String, Object>>) request.getAttribute("transactions");
%>

<%@ include file="/components/header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
         
.scroll {
  overflow: scroll; 
}

.scroll::-webkit-scrollbar {
  width: 8px;  
  height: 8px; 
}

.scroll::-webkit-scrollbar-thumb {
  background-color: gray;
  border-radius: 4px;  
}

.scroll::-webkit-scrollbar-track {
  background-color: transparent; /* Makes the track background invisible */
}

/* Firefox scrollbar style */
.scroll {
  scrollbar-width: thin;
  scrollbar-color: gray transparent; /* Thumb color and track color */
}
        </style>
</head>
<body class="bg-gray-900 text-gray-100">

    <!-- Main Layout -->
    <div class="flex min-h-screen">

        <!-- Admin Panel (Sidebar) -->
        <nav class="w-56 h-[90vh] bg-gray-800 shadow-xl ml-2 mt-2 mb-2 rounded-xl text-gray-200 p-6">
            <div class="flex flex-col items-center">
                <!-- Profile Image -->
                <img src="https://via.placeholder.com/100" alt="Profile Picture" class="w-24 h-24 rounded-full mb-4">
                <h2 class="text-2xl font-semibold text-white mb-2"><%= username %></h2>
                <p class="text-sm text-gray-400 mb-6"><%= email %></p>
            </div>
            <div class="h-[50vh] flex flex-col justify-between">
                <ul class="space-y-4">
                    <li>
                        <a href="balanceServlet" class="block px-4 py-2 rounded-lg text-sm font-medium bg-gray-900 border border-gray-300 hover:bg-gray-600 transition duration-300">View Balance</a>
                    </li>
                    <li>
                        <a href="creatorAuctionsServlet" class="block px-4 py-2 rounded-lg text-sm font-medium bg-gray-700 hover:bg-gray-600 transition duration-300">My Auctions</a>
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

        <!-- Main Section -->
        <section class="p-6 mx-3 w-full flex gap-3 ">
            <div class="w-full mt-6">
                 <h1 class="text-xl font-semibold  mb-6">Your Balance</h1>

            <!-- Balance Info -->
            <div class="balance-info mb-6 bg-gray-800 p-6 rounded-xl shadow-lg">
                <div class="flex items-center justify-between">
                    <h3 class="text-3xl font-bold text-green-400">Balance Amount:</h3>
                    <span class="text-3xl font-semibold text-white">$<%= balanceAmount != null ? balanceAmount : "0.00" %></span>
                </div>
            </div>

            <!-- Deposit Section -->
            <h2 class="text-xl font-semibold mb-6">Make a Deposit</h2>
       <form action="depositServlet" method="POST" class="bg-gray-800 p-6 rounded-xl shadow-lg space-y-4">
            <div>
                <label for="depositAmount" class="block text-sm font-medium mb-2">Deposit Amount ($)</label>
                <input type="number" id="depositAmount" name="depositAmount" class="w-full p-2 rounded-lg bg-gray-900 border border-gray-700 focus:outline-none focus:ring-2 focus:ring-green-500" placeholder="Enter amount" required>
            </div>

            <div>
                <label for="paymentMethod" class="block text-sm font-medium mb-2">Payment Method</label>
                <select id="paymentMethod" name="paymentMethod" class="w-full p-2 rounded bg-gray-900 border border-gray-700 focus:outline-none focus:ring-2 focus:ring-green-500">
                    <option value="credit_card">CBE</option>
                    <option value="paypal">Abyssinya</option>
                    <option value="bank_transfer">TeleBirr</option>
                </select>
            </div>

            <div>
                <label for="receiptUrl" class="block text-sm font-medium mb-2">Receipt Screenshot URL</label>
                <input type="url" id="receiptUrl" name="receiptUrl" class="w-full p-2 rounded-lg bg-gray-900 border border-gray-700 focus:outline-none focus:ring-2 focus:ring-green-500" placeholder="Paste receipt screenshot URL" required>
            </div>

            <div class="text-right">
                <button type="submit" class="px-6 py-2 bg-green-600 text-white font-medium rounded-lg hover:bg-green-500 transition duration-300">Deposit</button>
            </div>

            <p class="text-green-600"><%= request.getAttribute("successMessage") != null ? request.getAttribute("successMessage") : "" %></p>
            <p class="text-red-600"><%= request.getAttribute("errorMessage") != null ? request.getAttribute("errorMessage") : "" %></p>
        </form>


            </div>
           

            <div class="w-full h-[90vh] scroll overflow-scroll p-4">
                <h2 class="text-2xl font-semibold mx-5 mt-8 mb-6">Transaction History</h2>
                <div class="transaction-history space-y-4">
    <% 
        if (transactions != null && !transactions.isEmpty()) {
            SimpleDateFormat formatter = new SimpleDateFormat("MMMM dd, yyyy - hh:mm a");
            for (Map<String, Object> transaction : transactions) {
                Date createdAt = (Date) transaction.get("createdAt");
                String formattedDate = createdAt != null ? formatter.format(createdAt) : "Unknown Date";
    %>
    <div class="transaction-item p-4 bg-gray-800 rounded-xl shadow-lg transition-transform transform ">
        <div class="flex items-center justify-between mb-4">
            <div class="flex items-center space-x-3">
                <!-- Icon for Transaction -->
                <div class="bg-blue-500 p-2 rounded-full">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 14l6-6M15 10l-6 6" />
                    </svg>
                </div>
                <span class="text-lg font-semibold text-gray-100">Transaction ID: <%= transaction.get("transactionId") %></span>
            </div>
            <span class="text-sm text-gray-400"><%= formattedDate %></span>
        </div>
        <div class=" flex items-end justify-between gap-4">
            <div>
                <p class="text-gray-300"><span class="font-semibold text-gray-100">Type:</span> <%= transaction.get("type") %></p>
                <p class="text-gray-300"><span class="font-semibold text-gray-100">Status:</span> <%= transaction.get("transactionStatus") %></p>
            </div>
            <p class="text-green-300 text-xl"> $<%= transaction.get("amount") %></p>

        </div>
    </div>
    <% 
            }
        } else {
    %>
    <p class="text-gray-300">No transactions found for your account.</p>
    <% } %>
</div>

            </div>
            <!-- Transaction History -->
            
        </section>
    </div>


</body>
</html>
