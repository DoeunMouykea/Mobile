@extends('layouts.app')

@section('title', 'Blog Page')

@section('content')
<div class="card mb-4">
    <div class="card-header">
        <h2 class="mb-0 text-center ">Preview of Submitted Blog Data</h2>
    </div>
    <div class="card-body">
        @if (!empty($blogData))
            @foreach ($blogData as $data)
                <div class="preview-section">
                    <h4>Title: {{ htmlspecialchars($data['title']) }}</h4>
                    <p><strong>Content:</strong> {!! nl2br(e($data['content'])) !!}</p>

                    <p><label for="image">Image:</label>
                    <img src="{{ asset('storage/' . $data['image']) }}" alt="Image" width="200"></p>

                    <div class="row justify-content-start mt-3">
                        <div class="col-sm-10">
                            <a href="{{ route('edit_blog', ['id' => $data['id']]) }}" class="btn btn-warning">Edit</a>
                            <a href="{{ route('delete_blog', ['id' => $data['id']]) }}" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this record?')">Delete</a>
                        </div>
                    </div>
                </div>
                <hr>
            @endforeach
        @else
            <p>No blog data available to preview.</p>
        @endif
    </div>
</div>
@include('components.script')
@endsection
