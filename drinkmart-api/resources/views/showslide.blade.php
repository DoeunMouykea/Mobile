@extends('layouts.app')

@section('title', 'Showslide Page')

@section('content')
<!-- Slideshow Table -->
<div class="card">
    <h5 class="card-header text-center">Table Slideshow</h5>
    <div class="table-responsive text-nowrap">
        <table class="table">
            <caption class="ms-4">List of slides</caption>
            <thead>
                <tr>
                    <!-- Removed the Number column -->
                    <th>Image</th>
                    <th>Title</th>
                    <th>Description</th>
                    <th>Link</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody id="slideTableBody">
                <!-- Slideshow rows will be inserted here dynamically -->
            </tbody>
        </table>
    </div>
</div>

@include('components.script')

<script>
    // Fetch the slides data from the API
    async function fetchSlides() {
        try {
            const response = await fetch('http://127.0.0.1:8000/api/slideshows');
            const data = await response.json();

            if (response.ok) {
                const slideTableBody = document.getElementById('slideTableBody');
                slideTableBody.innerHTML = ''; // Clear existing rows

                // Loop through the slides data and create table rows
                data.forEach(slide => {
                    const row = document.createElement('tr');

                    row.innerHTML = `
                        <td><img src="${slide.image}" width="100" alt="${slide.title}"></td>
                        <td>${slide.title}</td>
                        <td>${slide.description.substring(0, 30)}...</td>
                        <td><a href="${slide.link}" target="_blank">${slide.link}</a></td>
                        <td>
                            <button class="btn btn-info btn-sm edit-slide"
                                    data-id="${slide.id}"
                                    data-title="${slide.title}"
                                    data-description="${slide.description}"
                                    data-link="${slide.link}"
                                    data-image="${slide.image}">
                                Edit
                            </button>
                            <button class="btn btn-danger btn-sm delete-slide" data-id="${slide.id}">
                                Delete
                            </button>
                        </td>
                    `;

                    slideTableBody.appendChild(row);
                });
            } else {
                alert('Failed to fetch slides');
            }
        } catch (error) {
            console.error('Error fetching slides:', error);
            alert('An error occurred while fetching the slides.');
        }
    }

    // Call fetchSlides when the page loads
    document.addEventListener('DOMContentLoaded', function() {
        fetchSlides();
    });

    // Add delete functionality (optional, add API integration for deletion)
    document.getElementById('slideTableBody').addEventListener('click', async function(e) {
        if (e.target.classList.contains('delete-slide')) {
            const slideId = e.target.getAttribute('data-id');
            if (confirm('Are you sure you want to delete this slide?')) {
                try {
                    const response = await fetch(`http://127.0.0.1:8000/api/slideshows/${slideId}`, {
                        method: 'DELETE',
                        headers: {
                            'Accept': 'application/json',
                        },
                    });

                    const data = await response.json();
                    if (response.ok) {
                        alert('Slide deleted successfully!');
                        fetchSlides(); // Reload slides after deletion
                    } else {
                        alert('Failed to delete slide');
                    }
                } catch (error) {
                    console.error('Error deleting slide:', error);
                    alert('An error occurred while deleting the slide.');
                }
            }
        }
    });
</script>

@endsection
