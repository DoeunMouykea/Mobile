<!DOCTYPE html>
<html lang="en">

@include('components.head')
<body>
@include('components.navbar')
<div class="main-panel">
    <div class="content-wrapper">
        <div class="row">
            <div class="col-sm-12">
                @yield('content')
                @include('components.footer')
            </div>
        </div>
    </div>
</div>
</body>
</html>
