@extends('layouts.app')

@section('title', 'Contact Information')

@section('content')
<div class="card">
    <h5 class="card-header">Contact Information</h5>
    <div class="table-responsive text-nowrap">
        <table class="table table-dark">
            <thead>
                <tr>
                    <th>No</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Message</th>
                    <th>Date</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody class="table-border-bottom-0">
                @foreach($contactData as $key => $contact)
                    <tr>
                        <td><strong>{{ $key + 1 }}</strong></td>
                        <td>{{ htmlspecialchars($contact->name) }}</td>
                        <td>{{ htmlspecialchars($contact->email) }}</td>
                        <td>{{ htmlspecialchars($contact->message) }}</td>
                        <td>{{ \Carbon\Carbon::parse($contact->created_at)->format('Y-m-d') }}</td>

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
