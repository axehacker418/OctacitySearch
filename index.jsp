<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Front Page</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .dropdown-item-button {
            border: none;
            background: none;
            width: 100%;
            text-align: left;
            padding: 0.5rem 1rem;
        }
    </style>
</head>
<body>
    <header>
        <h1 id="logo"><b>Saurabh.in</b></h1>
        <nav>
            <a class="abccc" href="login.html">Login</a>
            <a class="abccc" href="#">Ops</a>
            <a class="abccc" href="logout.jsp">Logout</a>
        </nav>
    </header>
    
    <main>
        <div class="dropdown">
            <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton" data-bs-toggle="dropdown" aria-expanded="false">
              Select City
            </button>
            <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                <li><button type="button" class="dropdown-item dropdown-item-button" onclick="setCityName('Gwalior')">Gwalior</button></li>
                <li><button type="button" class="dropdown-item dropdown-item-button" onclick="setCityName('Bhopal')">Bhopal</button></li>
                <!-- Add more cities as needed -->
            </ul>
        </div>

        <div id="serviceList">
            <h2>Services in <%= request.getAttribute("city") != null ? request.getAttribute("city") : "Selected City" %></h2>
            <ul class="list-group">
                <% 
                    ArrayList<String> services = (ArrayList<String>) request.getAttribute("services");
                    if (services != null) {
                        for (String service : services) {
                %>
                    <li class="list-group-item"><%= service %></li>
                <% 
                        }
                    } else { 
                %>
                    <li class="list-group-item">No services available.</li>
                <% } %>
            </ul>
        </div>
    </main>
    
    <footer>
        <p class="copyright">&copy; Saurabh.in</p>
        <p class="copyright">Contact: saurabhlakshkar321@gmail.com</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function setCityName(city) {
            const form = document.createElement('form');
            form.method = 'GET';
            form.action = 'search.jsp';

            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'cityName';
            input.value = city;

            form.appendChild(input);
            document.body.appendChild(form);
            form.submit();
        }
    </script>
</body>
</html>

