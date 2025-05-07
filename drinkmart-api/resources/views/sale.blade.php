@extends('layouts.app')

@section('title', 'About Page')

@section('content')
<div class="card">
    <h5 class="card-header text-center">Table Orders</h5>
    <div class="table-responsive text-nowrap">
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Quantity</th>
                    <th>Price</th>
                    <th>Order Id</th>
                    <th>Order Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody class="table-border-bottom-0">
            @foreach ($order_items as $item)

                <tr class="bg-light">
                    <td>{{ $item['id'] }}</td>
                    <td colspan="1">📦 <strong>{{ $item['name'] }}</strong></td>
                    <td>{{ $item['quantity'] }}</td>
                    <td>${{ number_format($item['price'], 2) }}</td>
                    <td>{{ $item['order_id'] }}</td>
                    <td>{{ \Carbon\Carbon::parse($item['created_at'])->format('M d, Y') }}</td>

                    <td>
                        <span class="badge bg-label-primary me-1">{{ $order['status'] ?? 'pending' }}</span>
                    </td>
                    <td>
                        <div class="dropdown">
                            <button type="button" class="btn p-0 dropdown-toggle hide-arrow" data-bs-toggle="dropdown">
                                <i class="bx bx-dots-vertical-rounded"></i>
                            </button>
                            <div class="dropdown-menu">
                                <a class="dropdown-item" href="#"><i class="bx bx-edit-alt me-1"></i> Edit</a>
                                <a class="dropdown-item" href="#"><i class="bx bx-trash me-1"></i> Delete</a>
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
