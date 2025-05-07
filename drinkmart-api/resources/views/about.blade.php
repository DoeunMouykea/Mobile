@extends('layouts.app')

@section('title', 'About Page')

@section('content')
<div class="card mb-4">
    <div class="card-header">
        <h5 class="mb-0 text-center">Create About Page</h5>
    </div>
    <div class="card-body">
        <form id="aboutForm" method="POST" enctype="multipart/form-data">
            @csrf
            <!-- Title Field -->
            <div class="row mb-3">
                <label class="col-sm-2 col-form-label" for="title">Title:</label>
                <div class="col-sm-10">
                    <input class="form-control" type="text" name="title" id="title" required>
                </div>
            </div>

            <!-- Content Field -->
            <div class="row mb-3">
                <label class="col-sm-2 col-form-label" for="content">Content:</label>
                <div class="col-sm-10">
                    <textarea class="form-control" name="content" id="content" rows="4" required></textarea>
                </div>
            </div>

            <!-- Image Field -->
            <div class="row mb-3">
                <label class="col-sm-2 col-form-label" for="image">Image:</label>
                <div class="col-sm-10">
                    <input class="form-control" type="file" name="image" id="image" required>
                </div>
            </div>

            <!-- Submit Button -->
            <div class="row justify-content-end">
                <div class="col-sm-10">
                    <button type="submit" class="btn btn-primary">Submit</button>
                </div>
            </div>
        </form>
    </div>
</div>

@include('components.script')

<script>
    document.getElementById('aboutForm').addEventListener('submit', async function (e) {
        e.preventDefault(); // Prevent the form from submitting normally

        const formData = new FormData(this); // Prepare the form data to send

        try {
            const response = await fetch('http://127.0.0.1:8000/api/abouts/about', {
                method: 'POST',
                body: formData,
                headers: {
                    'Accept': 'application/json',
                },
            });

            const data = await response.json();

            if (response.ok) {
                alert('About page created successfully!');
                // Optionally, you can clear the form here or redirect
                this.reset();
            } else {
                alert('Error: ' + (data.message || 'Failed to create about page'));
            }
        } catch (error) {
            console.error('Error:', error);
            alert('An error occurred while creating the about page.');
        }
    });
</script>

@endsection
