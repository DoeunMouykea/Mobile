@extends('layouts.app')

@section('title', 'Product Page')

@section('content')
<div class="card mb-4">
    <div class="card-header">
        <h5 class="mb-0 text-center">Create Product</h5>
    </div>
    <div class="card-body">
        <form id="productForm" enctype="multipart/form-data">
            @csrf
            <div class="row mb-3">
                <label class="col-sm-2 col-form-label" for="name">Name</label>
                <div class="col-sm-10">
                    <input type="text" name="name" class="form-control" id="name" placeholder="Product name" required />
                </div>
            </div>
            <div class="row mb-3">
                <label class="col-sm-2 col-form-label" for="category">Category</label>
                <div class="col-sm-10">
                    <input type="text" name="category" class="form-control" id="category" placeholder="Category" required />
                </div>
            </div>
            <div class="row mb-3">
                <label class="col-sm-2 col-form-label" for="material">Material</label>
                <div class="col-sm-10">
                    <input type="text" name="material" class="form-control" id="material" placeholder="Material" required />
                </div>
            </div><div class="row mb-3">
                <label class="col-sm-2 col-form-label" for="price">Price</label>
                <div class="col-sm-10">
                    <div class="input-group">
                        <span class="input-group-text">$</span>
                        <input type="number" name="price" class="form-control" id="price" placeholder="Amount" step="0.01" required />
                        <span class="input-group-text">.00</span>
                    </div>
                </div>
            </div>
            <div class="row mb-3">
                <label class="col-sm-2 col-form-label" for="description">Description</label>
                <div class="col-sm-10">
                    <textarea name="description" class="form-control" id="description" placeholder="Product description" required></textarea>
                </div>
            </div>
            <div class="row mb-3">
                <label class="col-sm-2 col-form-label" for="image">Image</label>
                <div class="col-sm-10">
                    <input class="form-control" type="file" name="image" id="image" accept="image/*" required />
                </div>
            </div><div class="row mb-3">
                <label class="col-sm-2 col-form-label" for="volume">Volume</label>
                <div class="col-sm-10">
                    <input type="text" name="volume" class="form-control" id="volume" placeholder="e.g. 330ml, 1L" required />
                </div>
            </div>
            <div class="row mb-3">
                <label class="col-sm-2 col-form-label" for="stock">Stock</label>
                <div class="col-sm-10">
                    <input class="form-control" type="number" name="stock" id="stock" value="0" required />
                </div>
            </div>
            <div class="row justify-content-end">
                <div class="col-sm-10">
                    <button type="submit" class="btn btn-primary">ADD</button>
                </div>
            </div>
        </form>
    </div>
</div>

@include('components.script')

<script>
document.getElementById('productForm').addEventListener('submit', async function(e) {
    e.preventDefault();

    const formData = new FormData(this);

    try {
        const response = await fetch('http://127.0.0.1:8000/api/products/product', {
            method: 'POST',
            body: formData,
            headers: {
                'Accept': 'application/json',
                // No Authorization header needed unless using token auth
            },
        });

        const data = await response.json();

        if (response.ok) {
            //alert('✅ Product created successfully!');
            window.location.href = '/showproduct'; // Update this if your route is different
        } else {
            alert('❌ Error: ' + (data.message || 'Failed to create product'));
        }
    } catch (error) {
        console.error('Error:', error);
        alert('❌ An error occurred. Please try again.');
    }
});
</script>
@endsection
