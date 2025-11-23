<?php

use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\DashboardsController;
use App\Http\Controllers\CRUDMedicosController;
use App\Http\Controllers\ConsultaExportController;


Route::get('/', function () {
    return redirect('/login');
});

Route::get('/home', function () {
    return view('welcome');
})->middleware(['auth', 'verified'])->name('home');

Route::get('/dashboard', [DashboardsController::class, 'index']
)->middleware(['auth', 'verified'])->name('dashboard');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

Route::resource('medicos', CRUDMedicosController::class);

Route::get('/consultas/exports', [ConsultaExportController::class, 'export'])->name('consultas.export');    

require __DIR__.'/auth.php';
