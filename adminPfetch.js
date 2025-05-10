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
