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
                <img src="{{ asset('icon.png') }}" alt="logo" width="100">
              </div>
              <h4>Hello! Let's get started</h4>
              <h6 class="fw-light">Sign in to continue.</h6>

              <div id="errorMessage" class="alert alert-danger d-none"></div>

              <form id="loginForm" class="pt-3">
                <div class="form-group mb-3">
                  <input type="email" id="email" class="form-control form-control-lg" placeholder="Email" required>
                </div>
                <div class="form-group mb-3">
                  <input type="password" id="password" class="form-control form-control-lg" placeholder="Password" required>
                </div>
                <div class="mt-3">
                  <button type="submit" class="btn btn-block btn-primary btn-lg font-weight-medium auth-form-btn">SIGN IN</button>
                </div>
                <div class="my-2 d-flex justify-content-between align-items-center">
                  <div class="form-check">
                    <input type="checkbox" class="form-check-input" id="remember">
                    <label class="form-check-label text-muted" for="remember">Keep me signed in</label>
                  </div>
                  <a href="#" class="auth-link text-black">Forgot password?</a>
                </div>
                <div class="mb-2">
                  <button type="button" class="btn btn-block btn-facebook auth-form-btn">
                    <i class="ti-facebook me-2"></i>Connect using Facebook
                  </button>
                </div>
                <div class="text-center mt-4 fw-light">
                  Don't have an account? <a href="/register" class="text-primary">Create</a>
                </div>
              </form>

            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  @include('components.script')

  <script>
    document.getElementById('loginForm').addEventListener('submit', function (e) {
      e.preventDefault();

      const email = document.getElementById('email').value;
      const password = document.getElementById('password').value;
      const errorMessage = document.getElementById('errorMessage');

      fetch('http://127.0.0.1:8000/api/auth/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email, password })
      })
      .then(response => response.json())
      .then(data => {
        if (data.access_token) {
          localStorage.setItem('access_token', data.access_token);
          window.location.href = '/'; // redirect after login
        } else {
          errorMessage.classList.remove('d-none');
          errorMessage.innerText = data.error || 'Login failed. Please check your credentials.';
        }
      })
      .catch(err => {
        errorMessage.classList.remove('d-none');
        errorMessage.innerText = 'An error occurred. Please try again.';
        console.error('Login error:', err);
      });
    });
  </script>
</body>
</html>
