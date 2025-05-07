<?php

namespace App\Exceptions;

use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
use Illuminate\Http\Exceptions\ThrottleRequestsException;
use Throwable;
use Symfony\Component\HttpFoundation\Response;

class Handler extends ExceptionHandler
{
    protected $levels = [];

    protected $dontReport = [];

    protected $dontFlash = [
        'current_password',
        'password',
        'password_confirmation',
    ];

    public function register(): void
    {
        $this->reportable(function (Throwable $e) {
            //
        });
    }

    public function render($request, Throwable $exception)
    {
        if ($exception instanceof ThrottleRequestsException) {
            return response()->json([
                'message' => 'អ្នកបានព្យាយាមចូលច្រើនលើសកំណត់។ សូមព្យាយាមម្តងទៀតក្រោយពីរយៈពេលខ្លី។'
            ], Response::HTTP_TOO_MANY_REQUESTS);
        }

        return parent::render($request, $exception);
    }
}
