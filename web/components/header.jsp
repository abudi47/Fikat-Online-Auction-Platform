

<!-- Header -->
<header class="header bg-gray-800 text-white p-4 flex justify-between items-center shadow-lg">
  <!-- Logo Section -->
  <div class="logo flex items-center gap-2">
    <img class="h-10" src="assets/images/logo.png" alt="Fikat Auction Logo" />
    <h1 class="text-xl font-bold">Fikat Auction</h1>
  </div>

  <!-- Navigation Links -->
  <nav class="hidden md:flex space-x-6">
    <a href="/app" class="text-sm font-medium hover:text-yellow-400 transition">Home</a>
    <a href="auctionServlet" class="text-sm font-medium hover:text-yellow-400 transition">Auctions</a>
   <!-- Inside the Navigation Section -->
<script>
   let isLoggedIn = <%= (username != null) ? "true" : "false" %>;
  const navContainer = document.currentScript.parentElement;
  if (isLoggedIn) {
    navContainer.innerHTML += `
      <a href="create_auction.jsp" class="text-sm font-medium hover:text-yellow-400 transition">Create Auction</a>
      <a href="balanceServlet" class="text-sm font-medium hover:text-yellow-400 transition">Profile</a>
      <a href="logoutServlet" class="text-sm font-medium text-red-500 hover:opacity-65 transition">Logout</a>
    `;
  } else {
    navContainer.innerHTML += `
      <a href="login.jsp" class="text-sm font-medium hover:text-yellow-400 transition">Login</a>
    `;
  }
</script>

  </nav>

  <!-- Mobile Menu Icon -->
  <div class="md:hidden">
    <button id="menu-toggle" class="text-2xl">
      <i class="fas fa-bars"></i>
    </button>
  </div>

  <!-- Mobile Menu -->
  <div id="mobile-menu" class="hidden absolute top-16 left-0 w-full bg-gray-800 text-white shadow-lg z-10">
    <nav class="flex flex-col space-y-4 p-4">
      <a href="#" class="text-sm font-medium hover:text-yellow-400 transition">Home</a>
      <a href="auctions.jsp" class="text-sm font-medium hover:text-yellow-400 transition">Auctions</a>
      <script>
        const mobileMenu = document.currentScript.parentElement;
        if (isLoggedIn) {
          mobileMenu.innerHTML += `
            <a href="create_auction.jsp" class="text-sm font-medium hover:text-yellow-400 transition">Create Auction</a>
            <a href="balanceServlet" class="text-sm font-medium hover:text-yellow-400 transition">Profile</a>
          `;
        } else {
          mobileMenu.innerHTML += `
            <a href="login.jsp" class="text-sm font-medium hover:text-yellow-400 transition">Login</a>
          `;
        }
      </script>
    </nav>
  </div>
  <script>
  const menuToggle = document.getElementById("menu-toggle");
  const mobileMenu = document.getElementById("mobile-menu");

  menuToggle.addEventListener("click", () => {
    mobileMenu.classList.toggle("hidden");
  });
</script>

</header>

