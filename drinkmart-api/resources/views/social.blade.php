@extends('layouts.app')

@section('title', 'About Page')

@section('content')
<div id="socialMediaForm">
    <div class="card-header">
        <h5 id="formTitle">Add URL Social Media</h5>
    </div>
    <div class="card-body">
        <form id="saveForm">
            @csrf
            <div class="mb-3">
                <label>Facebook</label>
                <input type="url" name="facebook" id="facebook" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>YouTube</label>
                <input type="url" name="youtube" id="youtube" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Twitter</label>
                <input type="url" name="twitter" id="twitter" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Telegram</label>
                <input type="url" name="telegram" id="telegram" class="form-control" required>
            </div>
            <div class="mb-3">
                <label>Pinterest</label>
                <input type="url" name="pinterest" id="pinterest" class="form-control">
            </div>
            <div class="mb-3">
                <label>Instagram</label>
                <input type="url" name="instagram" id="instagram" class="form-control">
            </div>
            <button type="submit" class="btn btn-success">Save</button>
            <button type="button" class="btn btn-secondary" onclick="hideForm()">Cancel</button>
        </form>
    </div>
</div>

@include('components.script')

<script>
    document.getElementById('saveForm').addEventListener('submit', async function(e) {
        e.preventDefault();

        const form = e.target;

        const data = {
            facebook: form.facebook.value,
            youtube: form.youtube.value,
            twitter: form.twitter.value,
            telegram: form.telegram.value,
            pinterest: form.pinterest.value,
            instagram: form.instagram.value,
        };

        try {
            const response = await fetch('http://127.0.0.1:8000/api/social-links/social-link', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                },
                body: JSON.stringify(data)
            });

            const result = await response.json();

            if (response.ok) {
                alert('Social media links saved successfully!');
                form.reset();
                hideForm();
            } else {
                alert('Error: ' + (result.message || 'Something went wrong.'));
            }

        } catch (error) {
            console.error('Error:', error);
            alert('Failed to save data. Please try again.');
        }
    });

    function hideForm() {
        document.getElementById('socialMediaForm').style.display = 'none';
    }
</script>
@endsection
