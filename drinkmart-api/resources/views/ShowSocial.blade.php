@extends('layouts.app')

@section('title', 'About Page')

@section('content')
<div class="card">
    <div class="card-header d-flex justify-content-between">
        <h5>Social Media URLs</h5>

    </div>
    <div class="card-body">
        <table class="table table-bordered">
            <thead>
                <tr>

                    <th>Facebook</th>
                    <th>YouTube</th>
                    <th>Twitter</th>
                    <th>Telegram</th>
                    <th>Pinterest</th>
                    <th>Instagram</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody id="socialMediaTable">
                <!-- JS will populate this -->
            </tbody>
        </table>
    </div>
</div>

@include('components.script')

<script>
    async function fetchSocialLinks() {
        try {
            const response = await fetch('http://127.0.0.1:8000/api/social-links/');
            const data = await response.json();

            const table = document.getElementById('socialMediaTable');
            table.innerHTML = '';

            data.forEach(link => {
                table.innerHTML += `
                    <tr id="row-${link.id}">
                        <td>${limitText(link.facebook ?? '', 20)}</td>
                        <td>${limitText(link.youtube ?? '', 20)}</td>
                        <td>${limitText(link.twitter ?? '', 20)}</td>
                        <td>${limitText(link.telegram ?? '', 20)}</td>
                        <td>${limitText(link.pinterest ?? '', 20)}</td>
                        <td>${limitText(link.instagram ?? '', 20)}</td>
                        <td>
                        <button class="btn btn-warning btn-sm " onclick="editRecord(${link.id})">Edit</button>
                        <button class="btn btn-danger btn-sm" onclick="deleteRecord(${link.id})">Delete</button>
                        </td>
                    </tr>
                `;
            });
        } catch (error) {
            console.error('Failed to fetch links:', error);
        }
    }

    function limitText(text, limit) {
    return text.length > limit ? text.substring(0, limit) + '...' : text;
    }

    function editRecord(id) {
        alert('Edit functionality coming soon. ID: ' + id);
        // You can expand this to populate a form for editing
    }

    function deleteRecord(id) {
        if (confirm('Are you sure you want to delete this link?')) {
            fetch(`http://127.0.0.1:8000/api/social-links/${id}`, {
                method: 'DELETE',
                headers: {
                    'Accept': 'application/json'
                }
            }).then(res => res.json()).then(result => {
                document.getElementById(`row-${id}`).remove();
                alert('Deleted successfully!');
            }).catch(err => {
                console.error(err);
                alert('Failed to delete.');
            });
        }
    }

    // Load data on page load
    document.addEventListener('DOMContentLoaded', fetchSocialLinks);
</script>
@endsection
