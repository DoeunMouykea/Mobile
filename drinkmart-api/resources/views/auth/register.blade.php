<!DOCTYPE html>
<html lang="en">
@include('components.head')
<body>
<div class="container-scroller">
  <div class="container-fluid page-body-wrapper full-page-wrapper">
    <div class="content-wrapper d-flex align-items-center auth px-0">
      <div class="row w-100 mx-0">
        <div class="col-lg-4 mx-auto">
          <div class="auth-form-light text-left py-5 px-4 px-sm-5">
            <div class="brand-logo text-center mb-4">
              <img src="{{ asset('icon.png') }}" alt="logo" />
            </div>
            <h4>New here?</h4>
            <h6 class="fw-light">Signing up is easy. It only takes a few steps</h6>

            @if ($errors->any())
                <div class="alert alert-danger">
                    <ul class="mb-0">
                        @foreach ($errors->all() as $error)
                            <li>{{ $error }}</li>
                        @endforeach
                    </ul>
                </div>
            @endif

            <form method="POST" action="{{ route('register') }}" class="pt-3">
              @csrf
              <div class="form-group mb-3">
                <input type="text" name="name" class="form-control form-control-lg" placeholder="Username" value="{{ old('name') }}" required>
              </div>
              <div class="form-group mb-3">
                <input type="email" name="email" class="form-control form-control-lg" placeholder="Email" value="{{ old('email') }}" required>
              </div>
              <div class="form-group mb-3">
                <select name="country" class="form-select form-select-lg" required>
                  <option value="">Country</option>
                  <option >Cambodia</option>
                  <option >United States of America</option>
                  <option >United Kingdom</option>
                  <option>India</option>
                  <option>Germany</option>
                  <option>Argentina</option>
                </select>
              </div>
              <div class="form-group mb-3">
                <input type="password" name="password" class="form-control form-control-lg" placeholder="Password" required>
              </div>
              <div class="form-group mb-4">
                <input type="password" name="password_confirmation" class="form-control form-control-lg" placeholder="Confirm Password" required>
              </div>
              <div class="form-check mb-4">
                <input type="checkbox" class="form-check-input" id="terms" required>
                <label class="form-check-label text-muted" for="terms">
                  I agree to all Terms &amp; Conditions
                </label>
              </div>
              <div class="mt-3 d-grid">
                <button type="submit" class="btn btn-primary btn-lg fw-medium auth-form-btn">SIGN UP</button>
              </div>
              <div class="text-center mt-4 fw-light">
                Already have an account? <a href="{{ route('login') }}" class="text-primary">Login</a>
              </div>
            </form>

          </div>
        </div>
      </div>
    </div>
  </div>
</div>
@include('components.script')
</body>
</html>
