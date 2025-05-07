<?php

namespace App\Providers;

use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Foundation\Support\Providers\RouteServiceProvider as ServiceProvider;

class RouteServiceProvider extends ServiceProvider
{
    public function boot(): void
    {
        RateLimiter::for('login', function ($request) {
            $email = (string) $request->email;

            return Limit::perMinutes(3, 1)->by($email);
            // 1 attempt per 3 minutes per email
        });

        // Optional: Call parent route loading if you haven't customized it
        parent::boot();
    }
}
