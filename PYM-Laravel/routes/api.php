<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\DashboardsController;

Route::get('/dashboardsData', [DashboardsController::class, 'getData']);   