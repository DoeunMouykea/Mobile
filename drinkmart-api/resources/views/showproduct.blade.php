@extends('layouts.app')

@section('title', 'All Products')

@section('content')
<div class="card">
    <h5 class="card-header text-center">Table Products</h5>
    <div class="table-responsive text-nowrap">
        <table class="table">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Image</th>
                    <th>Name</th>
                    <th>Material</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th>Description</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody class="table-border-bottom-0">
                @foreach ($products as $product)
                    <tr>
                        <td>{{ $product->id }}</td>
                        <td>
                            <img src="{{ asset($product->image) }}" width="80" height="90" />
                        </td>
                        <td>{{ Str::limit($product->name, 20) }}</td>
                        <td>{{ Str::limit($product->material, 10) }}</td>
                        <td>{{ Str::limit($product->category, 10) }}</td>
                        <td>${{ number_format($product->price, 2) }}</td>
                        <td>{{ $product->stock }}</td>
                        <td>{{ Str::limit($product->description, 50) }}</td>
                        <td>
                            <div class="dropdown">
                                <button type="button" class="btn p-0 dropdown-toggle" data-bs-toggle="dropdown">
                                    <i class="bx bx-dots-vertical-rounded"></i>
                                </button>
                                <div class="dropdown-menu">
                                    <a class="dropdown-item" href="{{ route('products.edit', $product->id) }}">
                                        <i class="bx bx-edit-alt me-1"></i> Edit
                                    </a>
                                    <form action="{{ route('products.destroy', $product->id) }}" method="POST" onsubmit="return confirm('Are you sure?')">
                                        @csrf
                                        @method('DELETE')
                                        <button class="dropdown-item" type="submit">
                                            <i class="bx bx-trash me-1"></i> Delete
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>
    </div>
</div>

@include('components.script')
@endsection
