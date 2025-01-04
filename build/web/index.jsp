

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
    <title>Fikat Auction</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://kit.fontawesome.com/a076d05399.js"></script>
      <style>
        .slider {
            display: flex;
            overflow-x: auto; /* Enable horizontal scrolling */
            scroll-behavior: smooth; /* Smooth scrolling */
            padding: 1rem 0; /* Optional padding */
            scrollbar-width: thin; /* For Firefox */
            scrollbar-color: #333 #0e0b24; /* For Firefox */
        }
        .slider::-webkit-scrollbar {
            height: 8px; /* Height of the scrollbar */
            background: #000; /* Background of the scrollbar */
        }
        .slider::-webkit-scrollbar-thumb {
            background-color: #333; /* Color of the scrollbar handle */
            border-radius: 10px; /* Rounded edges */
        }
        
    </style>
</head>

<body class="font-sans bg-gray-900 text-white transition-all">

    <!-- Intro Section -->
    <section class="intro flex items-center justify-center py-32 pb-16 pt-10 text-center text-white bg-gradient-to-r from-gray-800 to-gray-900 shadow-lg">
        <div class="flex w-[54%] flex-col items-start">
            <h2 class="text-4xl font-extrabold mb-4">Fikat Online Auction Platform</h2>
            <p class="text-lg text-start">Bid on a wide variety of unique items and win amazing products at the best prices. It's your time to shine in the world of auctions! Discover new opportunities, place your bids confidently, and experience the thrill of competitive bidding. </p>
            <div id="nav-links" class="mt-10 flex space-x-3">
                 <a href="create_auction.jsp" class="btn px-6 py-2 rounded-lg bg-blue-600 hover:bg-blue-700 transition-all">Create Auction</a>
                 <a href="auctionServlet" class="btn px-6 py-2 rounded-lg bg-blue-600 hover:bg-blue-700 transition-all">Start Bidding Auctions</a>
                
            </div>
        </div>
        <img class='w-[30%]' src="assets/images/auction_1.png" alt="alt"/>
    </section>

    <!-- Features Section -->
    <section class="features py-16 px-20 bg-gray-900">
        <h2 class="text-3xl font-semibold mb-12 px-6 text-white">At Fikats Auction We Provide </h2>
        <div class="features-grid grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 px-6">
            <!-- Feature 1 -->
            <div class="feature bg-gray-800 p-6 pt-3 rounded-lg shadow-lg text-center">
                <div class="icon flex justify-center text-blue-600 mb-2">
                    <img class="w-[40%]" src="assets/images/ico.png" alt="alt"/>
                </div>
                <h3 class="text-xl font-semibold text-white mb-2">Exciting Auctions</h3>
                <p class="text-gray-300">Participate in a wide variety of exciting auctions with great products up for grabs. Bid with confidence!</p>
            </div>

            <!-- Feature 2 -->
            <div class="feature bg-gray-800 p-6 pt-3 rounded-lg shadow-lg text-center">
                <div class="icon flex justify-center text-blue-600 mb-2">
                    <img class="w-[50%]" src="assets/images/secure.png" alt="alt"/>
                </div>
                <h3 class="text-xl font-semibold text-white mb-2">Secure Payments</h3>
                <p class="text-gray-300">All payments are processed securely, ensuring a safe and seamless experience when placing your bids.</p>
            </div>

            <!-- Feature 3 -->
            <div class="feature bg-gray-800 p-6 pt-3 rounded-lg shadow-lg text-center">
                <div class="icon flex justify-center text-blue-600 mb-2">
                    <img class="w-[42%]" src="assets/images/com_1.png" alt="alt"/>
                </div>
                <h3 class="text-xl font-semibold text-white mb-2">Community Driven</h3>
                <p class="text-gray-300">Join a vibrant community of buyers and sellers, all united by a shared passion for auctions and great deals.</p>
            </div>
        </div>
    </section>

    <!-- How It Works Section -->
    <section class="how-it-works py-16 bg-gray-800 text-white relative">
        <h2 class="text-3xl font-bold px-20 mb-6">How the Auction House Works</h2>

        <!-- Vertical Line Container -->
        <div class="absolute inset-0 flex justify-start">
            <div class="h-[80%] border-l-4 border-solid border-gray-600 mt-12"></div>
        </div>

        <!-- Steps Content -->
        <div class="steps px-6 md:px-12 lg:px-24 flex flex-col items-start space-y-16 relative pl-16">
            <!-- Step 1: Get Authenticated -->
            <div class="step flex items-start justify-start space-x-6">
                <div class="circle w-8 h-8 bg-blue-600 rounded-full flex items-center justify-center text-white font-semibold">
                    1
                </div>
                <div class="step-content flex flex-col space-y-4">
                    <h3 class="text-2xl font-semibold text-yellow-400">Step 1: Secure Your Account</h3>
                    <p class="text-lg text-gray-300">To get started, secure your account and enter the world of auctions. Sign up to begin your bidding adventure!</p>
                </div>
            </div>

            <!-- Step 2: List Your Auction -->
            <div class="step flex items-start justify-start space-x-6">
                <div class="circle w-8 h-8 bg-teal-600 rounded-full flex items-center justify-center text-white font-semibold">
                    2
                </div>
                <div class="step-content flex flex-col space-y-4">
                    <h3 class="text-2xl font-semibold text-yellow-400">Step 2: Show Off Your Product</h3>
                    <p class="text-lg text-gray-300">List your unique items for others to bid on. Get your products ready, set a starting price, and see the excitement unfold!</p>
                </div>
            </div>

            <!-- Step 3: Place Your Bids -->
            <div class="step flex items-start justify-start space-x-6">
                <div class="circle w-8 h-8 bg-indigo-600 rounded-full flex items-center justify-center text-white font-semibold">
                    3
                </div>
                <div class="step-content flex flex-col space-y-4">
                    <h3 class="text-2xl font-semibold text-yellow-400">Step 3: Place Your Winning Bid</h3>
                    <p class="text-lg text-gray-300">Explore live auctions, place your bids, and compete with other bidders to win the products you desire. The highest bid wins!</p>
                </div>
            </div>
        </div>
    </section>
    <%@ include file="/components/active_auctions.jsp" %>

    <%@ include file="/components/footer.jsp" %>

</body>

</html>
