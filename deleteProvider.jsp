<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Front Page</title>
    <link rel="stylesheet" href="index1.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
</head>
<body>
    <header>
        <h1 id="logo"><b>Octacitysearch.com</b></h1>
        <nav>
            <a class="abccc" href="logout.jsp">Logout</a>
        </nav>
    </header>
    
    <main class="centered-form">
        <div class="container form-container">
            <form id="cityForm">
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label for="cityDropdown" class="form-label">Select City</label>
                        <select id="cityDropdown" class="form-select form-select-lg">
                            <option value="" selected>Select a city</option>
                            <option value="Gwalior">Gwalior</option>
                            <option value="Indore">Indore</option>
                            <option value="Bhind">Bhind</option>
                            <option value="Morena">Morena</option>
                            <option value="Jhanshi">Jhanshi</option>
                            <option value="Guna">Guna</option>
                            <option value="Aagra">Aagra</option>
                            <option value="Bhopal">Bhopal</option>
                        </select>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="servicesDropdown" class="form-label">Select Service</label>
                        <select id="servicesDropdown" class="form-select form-select-lg">
                            <option value="" selected>Select a service</option>
                        </select>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="locationsDropdown" class="form-label">Select Location</label>
                        <select id="locationsDropdown" class="form-select form-select-lg">
                            <option value="" selected>Select a location</option>
                        </select>
                    </div>
                </div>
                
                <div class="row">
                    <div class="col">
                        <div class="mb-3">
                            <label for="providersTable" class="form-label">Provider Details</label>
                            <table id="providersTable" class="table table-striped">
                                <thead>
                                    <tr>
                                        <th scope="col">Name</th>
                                        <th scope="col">Contact</th>
                                        <th scope="col">Actions</th>
                                    </tr>
                                </thead>
                                <tbody id="providersTableBody">
                                    <!-- Example rows for testing -->
                                    <tr>
                                        <td>Provider 1</td>
                                        <td>Contact 1</td>
                                        <td><button class="btn btn-danger delete-btn" data-id="1">Delete</button></td>
                                    </tr>
                                    <tr>
                                        <td>Provider 2</td>
                                        <td>Contact 2</td>
                                        <td><button class="btn btn-danger delete-btn" data-id="2">Delete</button></td>
                                    </tr>
                                    <tr>
                                        <td>Provider 3</td>
                                        <td>Contact 3</td>
                                        <td><button class="btn btn-danger delete-btn" data-id="3">Delete</button></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </main>
   
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script>
        document.addEventListener('DOMContentLoaded', (event) => {
            document.getElementById('providersTableBody').addEventListener('click', function(event) {
                if (event.target && event.target.matches('.delete-btn')) {
                    const providerId = event.target.getAttribute('data-id');
                    if (confirm('Are you sure you want to delete this provider?')) {
                        deleteProvider(providerId);
                    }
                }
            });
        });

        function deleteProvider(providerId) {
            fetch('deleteProvider.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: new URLSearchParams({ 'id': providerId })
            })
            .then(response => response.text())
            .then(data => {
                if (data.trim() === 'success') {
                    document.querySelector(`button[data-id='${providerId}']`).closest('tr').remove();
                } else {
                    alert('Failed to delete the provider.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });
        }
    </script>

    <footer>
        <p class="copyright">&copy;OctaCitySearch.com 2024</p>
        <br>
        <p class="copyright">Contact: saurabhlakshkar321@gmail.com</p>
    </footer>
</body>
</html>
