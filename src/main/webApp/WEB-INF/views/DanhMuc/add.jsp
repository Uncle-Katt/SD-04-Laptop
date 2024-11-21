<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page language="java" pageEncoding="UTF-8" %>

<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Danh Mục</title>
</head>
<body>
<h1>Thêm Danh Mục</h1>
<form action="/danh-muc/add" method="post">
    <label for="ma">Mã:</label>
    <input type="text" id="ma" name="ma" required><br>

    <label for="tenDanhMuc">Tên Danh Mục:</label>
    <input type="text" id="tenDanhMuc" name="tenDanhMuc" required><br>

    <label for="moTa">Mô Tả:</label>
    <textarea id="moTa" name="moTa"></textarea><br>

    <input type="submit" value="Thêm">
</form>
<a href="/danh-muc/index">Trở về</a>
</body>
</html>