const urlParams = new URLSearchParams(window.location.search);
const ctnm = urlParams.get('ctnm');
const cnm = urlParams.get('cnm');

window.onload = function() {
    if (!ctnm) {
        // Redirect to index.html if ctnm is not present
        window.location.href = "index.html";
    } else {
        // Proceed with populating services dropdown
        populateServices();
    }

    
}

const cityDropdown = document.getElementById('cityDropdown');
const servicesDropdown = document.getElementById('servicesDropdown');
const locationsDropdown = document.getElementById('locationsDropdown');
const providersTableBody = document.getElementById('providersTableBody');

// Function to populate services dropdown based on selected city
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
    fetch(`fetchLocations.jsp?serviceName=${encodeURIComponent(selectedService)}&cityName=${encodeURIComponent(selectedCity)}`)
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

                    // Create cells for name and contact
                    const nameCell = document.createElement('td');
                    const contactCell = document.createElement('td');

                    // Populate cells with provider details
                    nameCell.textContent = provider.pname;
                    contactCell.textContent = provider.pcontect;

                    // Append cells to the row
                    row.appendChild(nameCell);
                    row.appendChild(contactCell);

                    // Append row to the table body
                    providersTableBody.appendChild(row);
                });
            } else {
                // If no providers available, show a message
                const row = document.createElement('tr');
                const cell = document.createElement('td');
                cell.colSpan = 2; // Span across two columns
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

// Populate services dropdown on page load if ctnm is present
if (ctnm) {
    populateServices();
}
