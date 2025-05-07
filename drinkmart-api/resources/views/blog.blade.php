@extends('layouts.app')

@section('title', 'Blog Page')

@section('content')
<div class="card mb-4">
    <div class="card-header">
        <h5 class="mb-0 text-center">Create Blog</h5>
    </div>
    <div class="card-body">
        <form id="blogForm" method="POST" enctype="multipart/form-data" >
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
    document.getElementById('blogForm').addEventListener('submit', async function (event) {
        event.preventDefault();

        const formData = new FormData(this); // Form data including file and text inputs

        try {
            const response = await fetch('http://127.0.0.1:8000/api/blogs/blog', {
                method: 'POST',
                body: formData, // Automatically handles file uploads
                headers: {
                    'Accept': 'application/json',
                },
            });

            if (response.ok) {
                alert('Blog created successfully!');
                // Optionally, redirect the user to the blog list page or reset the form
                window.location.href = '/showblog'; // Redirect to the list page after successful creation
            } else {
                const errorData = await response.json();
                alert('Error: ' + errorData.message);
            }
        } catch (error) {
            console.error('Error:', error);
            alert('An error occurred while creating the blog.');
        }
    });
</script>
@endsection
