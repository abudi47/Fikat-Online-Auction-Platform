<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Form</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-900 flex justify-center items-center h-screen text-white">

    <div class="bg-gray-800 p-8 rounded-lg shadow-xl w-full max-w-sm text-center">
        <h1 class="text-xl font-semibold mb-6 text-white tracking-wide">Login to your Account</h1>
        <form action="loginServlet" method="POST">
            <label for="email" class="block text-lg text-gray-400 mb-2 text-left">Email:</label>
            <input type="email" id="email" name="email" required
                class="w-full p-4 py-2 mb-5 bg-gray-700 text-white border border-gray-600 rounded-md focus:outline-none focus:bg-gray-600 focus:border-blue-500 transition duration-300">

            <label for="password" class="block text-lg text-gray-400 mb-2 text-left">Password:</label>
            <input type="password" id="password" name="password" required
                class="w-full p-4 py-2 mb-5 bg-gray-700 text-white border border-gray-600 rounded-md focus:outline-none focus:bg-gray-600 focus:border-blue-500 transition duration-300">

            <!-- Error message block -->
            <c:if test="${not empty errorMessage}">
                <p class="text-red-500 text-sm mb-3">${errorMessage}</p>
            </c:if>

            <input type="submit" value="Login"
                class="w-full p-4 py-2 bg-blue-500 text-white font-medium text-lg rounded-md cursor-pointer transition duration-300 hover:bg-blue-600 transform hover:scale-105">

        </form>

        <div class="mt-6 text-sm text-gray-400">
            <p>Don't have an account? <a href="register.jsp" class="text-blue-400 hover:underline font-bold">Register here</a></p>
        </div>
    </div>

</body>

</html>
