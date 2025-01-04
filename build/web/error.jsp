<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Error Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8d7da;
            color: #721c24;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .error-container {
            background-color: #f5c6cb;
            border: 1px solid #f5c2c7;
            border-radius: 5px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        h1 {
            font-size: 24px;
            margin-bottom: 10px;
        }
        p {
            font-size: 16px;
            margin-bottom: 20px;
        }
        a {
            display: inline-block;
            padding: 10px 20px;
            font-size: 14px;
            color: #721c24;
            background-color: #f8d7da;
            border: 1px solid #721c24;
            border-radius: 3px;
            text-decoration: none;
            transition: background-color 0.2s;
        }
        a:hover {
            background-color: #721c24;
            color: #fff;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <h1>An Error Occurred</h1>
        <p>${errorMessage}</p>
        <a href="javascript:history.back()">Go Back</a>
        <a href="index.jsp">Return to Home</a>
    </div>
</body>
</html>
