function populateServicesDropdown() {
    const servicesDropdown = document.getElementById('servicesDropdown');

    // Make an AJAX request to fetch services from database
    fetch('search.jsp') // Replace with your endpoint to fetch services
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            // Clear existing options except the first one
            while (servicesDropdown.options.length > 1) {
                servicesDropdown.remove(servicesDropdown.options.length - 1);
            }

            // Populate services dropdown with fetched data
            if (data && data.services && data.services.length > 0) {
                data.services.forEach(service => {
                    const option = document.createElement('option');
                    option.value = service;
                    option.textContent = service;
                    servicesDropdown.appendChild(option);
                });
            } else {
                // If no services available, show a message
                const option = document.createElement('option');
                option.value = '';
                option.textContent = 'No services available';
                servicesDropdown.appendChild(option);
            }
        })
        .catch(error => {
            console.error('Error fetching services:', error);
            // Handle the error here, e.g., display a message to the user
        });
}

function populateLocationsDropdown(serviceName) {
    const locationsDropdown = document.getElementById('locationsDropdown');

    // Make an AJAX request to fetch locations based on selected service
    fetch('fetchServices.jsp?serviceName=' + encodeURIComponent(serviceName))
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            // Clear existing options except the first one
            while (locationsDropdown.options.length > 1) {
                locationsDropdown.remove(locationsDropdown.options.length - 1);
            }

            // Populate locations dropdown with fetched data
            if (data && data.locations && data.locations.length > 0) {
                data.locations.forEach(location => {
                    const option = document.createElement('option');
                    option.value = location;
                    option.textContent = location;
                    locationsDropdown.appendChild(option);
                });
            } else {
                // If no locations available, show a message
                const option = document.createElement('option');
                option.value = '';
                option.textContent = 'No locations available';
                locationsDropdown.appendChild(option);
            }
        })
        .catch(error => {
            console.error('Error fetching locations:', error);
            // Handle the error here, e.g., display a message to the user
        });
}

// Event listener for services dropdown change
document.getElementById('servicesDropdown').addEventListener('change', function() {
    const selectedService = this.value;
    if (selectedService !== '') {
        populateLocationsDropdown(selectedService);
    } else {
        // Clear locations dropdown if no service selected
        const locationsDropdown = document.getElementById('locationsDropdown');
        locationsDropdown.innerHTML = '';
    }
});

// Call populateServicesDropdown function to populate services dropdown on page load
populateServicesDropdown();





































// Function to populate services dropdown based on selected city
function populateServices() {
    const cityDropdown = document.getElementById('cityDropdown');
    const selectedCity = cityDropdown.value;
    const servicesDropdown = document.getElementById('servicesDropdown');

    // Make an AJAX request to fetch services based on selected city
    fetch('fetchServices.jsp?cityName=' + encodeURIComponent(selectedCity))
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            // Clear existing options
            while (servicesDropdown.options.length > 1) {
                servicesDropdown.remove(servicesDropdown.options.length - 1);
            }

            // servicesDropdown.innerHTML = '';

            // Populate services dropdown with fetched data
            if (data && data.services && data.services.length > 0) {
                data.services.forEach(service => {
                    const option = document.createElement('option');
                    option.value = service;
                    option.textContent = service;
                    servicesDropdown.appendChild(option);
                });
            } else {
                // If no services available, show a default message
                const option = document.createElement('option');
                option.value = '';
                option.textContent = 'No services available';
                servicesDropdown.appendChild(option);
            }
        })
        .catch(error => {
            console.error('Error fetching services:', error);
            // Example of handling the error: display an alert to the user
            alert('Failed to fetch services. Please try again later.');
        });
}

// Function to populate locations dropdown based on selected service
function populateLocations(selectedService) {

    const locationsDropdown = document.getElementById('locationsDropdown');

    // Make an AJAX request to fetch locations based on selected service
    fetch('fetchLocations.jsp?serviceName=' + encodeURIComponent(selectedService))
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            // Clear existing options

            locationsDropdown.innerHTML = '';

            // Populate locations dropdown with fetched data
            if (data && data.locations && data.locations.length > 0) {
                data.locations.forEach(location => {
                    const option = document.createElement('option');
                    option.value = location;
                    option.textContent = location;
                    locationsDropdown.appendChild(option);
                });
            } else {
                // If no locations available, show a default message
                const option = document.createElement('option');
                option.value = '';
                option.textContent = 'No locations available';
                locationsDropdown.appendChild(option);
            }
        })
        .catch(error => {
            console.error('Error fetching locations:', error);
            // Example of handling the error: display an alert to the user
            alert('Failed to fetch locations. Please try again later.');
        });
}

// Function to fetch and populate provider details based on selected city and service
function fetchProviderDetails(cityName, serviceName) {
    const providersTableBody = document.getElementById('providersTableBody');

    // Make an AJAX request to fetch provider details based on selected city and service
    fetch('providers.jsp?cityName=' + encodeURIComponent(cityName) + '&serviceName=' + encodeURIComponent(serviceName))
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            // Clear existing table rows
            // providersTableBody.innerHTML = '';
            while (servicesDropdown.options.length > 1) {
                servicesDropdown.remove(servicesDropdown.options.length - 1);
            }


            // Populate table with fetched provider details
            if (data && data.providers && data.providers.length > 0) {
                data.providers.forEach(provider => {
                    const row = document.createElement('tr');
                    const nameCell = document.createElement('td');
                    const contactCell = document.createElement('td');

                    nameCell.textContent = provider.pname;
                    contactCell.textContent = provider.pcontect;

                    row.appendChild(nameCell);
                    row.appendChild(contactCell);

                    providersTableBody.appendChild(row);
                });
            } else {
                // If no providers available, show a message
                const row = document.createElement('tr');
                const cell = document.createElement('td');
                cell.colSpan = 2;
                cell.textContent = 'No providers available';
                row.appendChild(cell);
                providersTableBody.appendChild(row);
            }
        })
        .catch(error => {
            console.error('Error fetching provider details:', error);
            // Example of handling the error: display an alert to the user
            alert('Failed to fetch provider details. Please try again later.');
        });
}

// Event listener for services dropdown change
document.getElementById('servicesDropdown').addEventListener('change', function() {
    const selectedService = this.value;
    if (selectedService !== '') {
        populateLocations(selectedService);
    } else {
        const locationsDropdown = document.getElementById('locationsDropdown');
        locationsDropdown.innerHTML = '<option value="" selected>Select a location</option>';
    }
});

// Event listener for locations dropdown change
document.getElementById('locationsDropdown').addEventListener('change', function() {
    const selectedCity = document.getElementById('cityDropdown').value;
    const selectedService = document.getElementById('servicesDropdown').value;
    const selectedLocation = this.value;

    if (selectedCity !== '' && selectedService !== '' && selectedLocation !== '') {
        fetchProviderDetails(selectedCity, selectedService);
    } else {
        const providersTableBody = document.getElementById('providersTableBody');
        providersTableBody.innerHTML = '';
    }
});

// Populate services dropdown on page load
populateServices();










































// Function to populate services dropdown based on selected city
function populateServices() {
    const cityDropdown = document.getElementById('cityDropdown');
    const selectedCity = cityDropdown.value;
    const servicesDropdown = document.getElementById('servicesDropdown');

    // Make an AJAX request to fetch services based on selected city
    fetch('fetchServices.jsp?cityName=' + encodeURIComponent(selectedCity))
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            // Clear existing options but keep the default one
            servicesDropdown.innerHTML = '<option value="" selected>Select a service</option>';

            // Populate services dropdown with fetched data
            if (data && data.services && data.services.length > 0) {
                data.services.forEach(service => {
                    const option = document.createElement('option');
                    option.value = service;
                    option.textContent = service;
                    servicesDropdown.appendChild(option);
                });
            } else {
                // If no services available, show a default message
                const option = document.createElement('option');
                option.value = '';
                option.textContent = 'No services available';
                servicesDropdown.appendChild(option);
            }
        })
        .catch(error => {
            console.error('Error fetching services:', error);
            // Example of handling the error: display an alert to the user
            alert('Failed to fetch services. Please try again later.');
        });
}

// Function to populate locations dropdown based on selected service
function populateLocations(selectedService) {
    const locationsDropdown = document.getElementById('locationsDropdown');

    // Make an AJAX request to fetch locations based on selected service
    fetch('fetchLocations.jsp?serviceName=' + encodeURIComponent(selectedService))
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            // Clear existing options but keep the default one
            locationsDropdown.innerHTML = '<option value="" selected>Select a location</option>';

            // Populate locations dropdown with fetched data
            if (data && data.locations && data.locations.length > 0) {
                data.locations.forEach(location => {
                    const option = document.createElement('option');
                    option.value = location;
                    option.textContent = location;
                    locationsDropdown.appendChild(option);
                });
            } else {
                // If no locations available, show a default message
                const option = document.createElement('option');
                option.value = '';
                option.textContent = 'No locations available';
                locationsDropdown.appendChild(option);
            }
        })
        .catch(error => {
            console.error('Error fetching locations:', error);
            // Example of handling the error: display an alert to the user
            alert('Failed to fetch locations. Please try again later.');
        });
}

// Function to fetch and populate provider details based on selected city, service, and location
function fetchProviderDetails(cityName, serviceName, locationName) {
    const providersTableBody = document.getElementById('providersTableBody');

    // Make an AJAX request to fetch provider details based on selected city, service, and location
    fetch(`providers.jsp?cityName=${encodeURIComponent(cityName)}&serviceName=${encodeURIComponent(serviceName)}&locationName=${encodeURIComponent(locationName)}`)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            // Clear existing table rows
            providersTableBody.innerHTML = '';

            // Populate table with fetched provider details
            if (data && data.providers && data.providers.length > 0) {
                data.providers.forEach(provider => {
                    const row = document.createElement('tr');
                    const nameCell = document.createElement('td');
                    const contactCell = document.createElement('td');

                    nameCell.textContent = provider.pname;
                    contactCell.textContent = provider.pcontact;

                    row.appendChild(nameCell);
                    row.appendChild(contactCell);

                    providersTableBody.appendChild(row);
                });
            } else {
                // If no providers available, show a message
                const row = document.createElement('tr');
                const cell = document.createElement('td');
                cell.colSpan = 2;
                cell.textContent = 'No providers available';
                row.appendChild(cell);
                providersTableBody.appendChild(row);
            }
        })
        .catch(error => {
            console.error('Error fetching provider details:', error);
            // Example of handling the error: display an alert to the user
            alert('Failed to fetch provider details. Please try again later.');
        });
}

// Event listener for services dropdown change
document.getElementById('servicesDropdown').addEventListener('change', function() {
    const selectedService = this.value;
    const locationsDropdown = document.getElementById('locationsDropdown');
    locationsDropdown.innerHTML = '<option value="" selected>Select a location</option>'; // Reset locations dropdown

    if (selectedService !== '') {
        populateLocations(selectedService);
    } else {
        locationsDropdown.innerHTML = '<option value="" selected>Select a location</option>';
    }
});

// Event listener for locations dropdown change
document.getElementById('locationsDropdown').addEventListener('change', function() {
    const selectedCity = document.getElementById('cityDropdown').value;
    const selectedService = document.getElementById('servicesDropdown').value;
    const selectedLocation = this.value;

    if (selectedCity !== '' && selectedService !== '' && selectedLocation !== '') {
        fetchProviderDetails(selectedCity, selectedService, selectedLocation);
    } else {
        const providersTableBody = document.getElementById('providersTableBody');
        providersTableBody.innerHTML = '';
    }
});

// Event listener for city dropdown change
document.getElementById('cityDropdown').addEventListener('change', function() {
    populateServices();
    const servicesDropdown = document.getElementById('servicesDropdown');
    servicesDropdown.innerHTML = '<option value="" selected>Select a service</option>';
    const locationsDropdown = document.getElementById('locationsDropdown');
    locationsDropdown.innerHTML = '<option value="" selected>Select a location</option>';
    const providersTableBody = document.getElementById('providersTableBody');
    providersTableBody.innerHTML = '';
});

// Populate services dropdown on page load
populateServices();









window.onload = function() {
    // Function to populate services dropdown based on selected city
        const cityDropdown = document.getElementById('cityDropdown');
        const servicesDropdown = document.getElementById('servicesDropdown');
        const locationsDropdown = document.getElementById('locationsDropdown');
        const providersTableBody = document.getElementById('providersTableBody');

        function populateServices() {
            const selectedCity = cityDropdown.value;

            // Make an AJAX request to fetch services based on selected city
            fetch('fetchServices.jsp?cityName=' + encodeURIComponent(selectedCity))
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    // Clear existing options but keep the default one
                    servicesDropdown.innerHTML = '<option value="" selected>Select a service</option>';

                    // Populate services dropdown with fetched data
                    if (data && data.services && data.services.length > 0) {
                        data.services.forEach(service => {
                            const option = document.createElement('option');
                            option.value = service;
                            option.textContent = service;
                            servicesDropdown.appendChild(option);
                        });
                    } else {
                        // If no services available, show a default message
                        const option = document.createElement('option');
                        option.value = '';
                        option.textContent = 'No services available';
                        servicesDropdown.appendChild(option);
                    }
                })
                .catch(error => {
                    console.error('Error fetching services:', error);
                    alert('Failed to fetch services. Please try again later.');
                });
        }

        // Function to populate locations dropdown based on selected service and city
        function populateLocations(selectedCity, selectedService) {
            // Make an AJAX request to fetch locations based on selected service and city
            fetch('fetchLocations.jsp?serviceName=' + encodeURIComponent(selectedService) + '&cityName=' + encodeURIComponent(selectedCity))
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    // Clear existing options but keep the default one
                    locationsDropdown.innerHTML = '<option value="" selected>Select a location</option>';

                    // Populate locations dropdown with fetched data
                    if (data && data.locations && data.locations.length > 0) {
                        data.locations.forEach(location => {
                            const option = document.createElement('option');
                            option.value = location;
                            option.textContent = location;
                            locationsDropdown.appendChild(option);
                        });
                    } else {
                        // If no locations available, show a default message
                        const option = document.createElement('option');
                        option.value = '';
                        option.textContent = 'No locations available';
                        locationsDropdown.appendChild(option);
                    }
                })
                .catch(error => {
                    console.error('Error fetching locations:', error);
                    alert('Failed to fetch locations. Please try again later.');
                });
        }

        // Function to fetch and populate provider details based on selected city, service, and location
        function fetchProviderDetails(cityName, serviceName, locationName) {
            // Make an AJAX request to fetch provider details based on selected city, service, and location
            fetch(`providers.jsp?cityName=${encodeURIComponent(cityName)}&serviceName=${encodeURIComponent(serviceName)}&locationName=${encodeURIComponent(locationName)}`)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    // Clear existing table rows
                    providersTableBody.innerHTML = '';

                    // Populate table with fetched provider details
                    if (data && data.providers && data.providers.length > 0) {
                        data.providers.forEach(provider => {
                            const row = document.createElement('tr');

                            // Create cells for name, address, and contact
                            const nameCell = document.createElement('td');
                            const addressCell = document.createElement('td');
                            const contactCell = document.createElement('td');

                            // Populate cells with provider details
                            nameCell.textContent = provider.pname;
                            addressCell.textContent = provider.paddress; // Assuming this property exists in your provider data
                            contactCell.textContent = provider.pcontact;

                            // Append cells to the row
                            row.appendChild(nameCell);
                            row.appendChild(addressCell);
                            row.appendChild(contactCell);

                            // Append row to the table body
                            providersTableBody.appendChild(row);
                        });
                    } else {
                        // If no providers available, show a message
                        const row = document.createElement('tr');
                        const cell = document.createElement('td');
                        cell.colSpan = 3;
                        cell.textContent = 'No providers available';
                        row.appendChild(cell);
                        providersTableBody.appendChild(row);
                    }
                })
                .catch(error => {
                    console.error('Error fetching provider details:', error);
                    alert('Failed to fetch provider details. Please try again later.');
                });
        }

        // Event listener for services dropdown change
        servicesDropdown.addEventListener('change', function() {
            const selectedCity = cityDropdown.value;
            const selectedService = this.value;
            locationsDropdown.innerHTML = '<option value="" selected>Select a location</option>'; // Reset locations dropdown

            if (selectedService !== '') {
                populateLocations(selectedCity, selectedService);
            } else {
                locationsDropdown.innerHTML = '<option value="" selected>Select a location</option>';
            }
        });

        // Event listener for locations dropdown change
        locationsDropdown.addEventListener('change', function() {
            const selectedCity = cityDropdown.value;
            const selectedService = servicesDropdown.value;
            const selectedLocation = this.value;

            if (selectedCity !== '' && selectedService !== '' && selectedLocation !== '') {
                fetchProviderDetails(selectedCity, selectedService, selectedLocation);
            } else {
                providersTableBody.innerHTML = '';
            }
        });

        // Event listener for city dropdown change
        cityDropdown.addEventListener('change', function() {
            populateServices();
            servicesDropdown.innerHTML = '<option value="" selected>Select a service</option>';
            locationsDropdown.innerHTML = '<option value="" selected>Select a location</option>';
            providersTableBody.innerHTML = '';
        });

        // Populate services dropdown on page load
        populateServices();

    }
