@extends('layouts.app')

@section('title', 'About Page')

@section('content')
<div class="card">
    <h5 class="card-header text-center">Table Orders</h5>
    <div class="table-responsive text-nowrap">
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Invoice</th>
                    <th>Name Customer</th>
                    <th>Phone number</th>
                    <th>Address</th>
                    <th>Payment Method</th>
                    <th>Order Date</th>
                    <th>Total</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody class="table-border-bottom-0">
                @foreach ($orders as $order)
                <tr>
                    <td>{{ $order['id'] }}</td>
                    <td>{{ $order['first_name'] ?? '' }} {{ $order['last_name'] ?? '' }}</td>
                    <td>{{ $order['phone'] ?? 'N/A' }}</td>
                    <td>{{ $order['address'] ?? '' }}, {{ $order['city'] ?? '' }}, {{ $order['country'] ?? '' }}</td>
                    <td>{{ $order['payment_method'] ?? 'N/A' }}</td>
                    <td>{{ \Carbon\Carbon::parse($order['created_at'])->format('M d, Y') }}</td>
                    <td>{{ number_format($order['total'], 2) }}</td>
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
