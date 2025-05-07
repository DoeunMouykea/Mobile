@extends('layouts.app')

@section('title', 'About Page')

@section('content')
<div class="card mb-4">
    <div class="card-header">
        <h2 class="mb-0 text-center">Preview of Submitted Data</h2>
    </div>
    <div class="card-body">
        @if (!empty($aboutData))
            @foreach ($aboutData as $data)
                <div class="preview-section">
                    <h3>Title: {{ htmlspecialchars($data->title) }}</h3>
                    <p style="font-sixe: 16"><strong>Content:</strong> {!! nl2br(e($data->content)) !!}</p>

                    <p><strong for="image">Image:</strong>
                    <img class="m-3 " src="{{ asset('storage/'.$data->image) }}" alt="Image" width="200"></p>

                    <!-- Edit and Delete buttons -->
                    <div class="row justify-content-start">
                        <div class="col-sm-10 mt-5">
                            <a href="{{ route('edit_about', ['id' => $data->id]) }}" class="btn btn-warning">Edit</a>
                            <a href="{{ route('delete_about', ['id' => $data->id]) }}" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this record?')">Delete</a>
                        </div>
                    </div>
                </div>
                <hr>
            @endforeach
        @else
            <p>No data available to preview.</p>
        @endif
    </div>
</div>

@include('components.script')
@endsection
