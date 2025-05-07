@extends('layouts.app')

@section('title', 'Slideshow Page')

@section('content')

<div class="">
    <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title">Add Slideshow</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
            <form id="slideForm" method="POST" enctype="multipart/form-data">
                @csrf
                <div class="mb-3">
                    <label class="form-label">Title</label>
                    <input type="text" name="title" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control" required></textarea>
                </div>
                <div class="mb-3">
                    <label class="form-label">Link</label>
                    <input type="text" name="link" class="form-control">
                </div>
                <div class="mb-3">
                    <label class="form-label">Order Number</label>
                    <input type="number" name="order_number" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Image</label>
                    <input type="file" name="image" class="form-control" accept="image/*" required>
                </div>
                <button type="submit" class="btn btn-success">Save</button>
            </form>
        </div>
    </div>
</div>



@include('components.script')

<script>
document.getElementById('slideForm').addEventListener('submit', async function(e) {
    e.preventDefault(); // Prevent form from submitting normally

    const formData = new FormData(this); // Prepare the form data

    try {
        const response = await fetch('http://127.0.0.1:8000/api/slideshows/slideshow', {
            method: 'POST',
            body: formData,
            headers: {
                'Accept': 'application/json'
            }
        });

        const data = await response.json();

        if (response.ok) {
            alert('Slideshow added successfully!');
            displaySlideshow(data); // Show the new slideshow on the page
        } else {
            alert('Error: ' + (data.message || 'Failed to add slideshow'));
        }
    } catch (error) {
        console.error('Error:', error);
        alert('An error occurred. Please try again.');
    }
});

// Function to display the slideshow after creation
function displaySlideshow(data) {
    const slideshowDisplay = document.getElementById('slideshowDisplay');
    slideshowDisplay.innerHTML = `
        <div class="slideshow-item">
            <h4>${data.title}</h4>
            <p>${data.description}</p>
            <a href="${data.link}" target="_blank">${data.link}</a>
            <img src="${data.image}" alt="${data.title}" style="max-width: 100%; height: auto;">
        </div>
    `;
}
</script>
@endsection
