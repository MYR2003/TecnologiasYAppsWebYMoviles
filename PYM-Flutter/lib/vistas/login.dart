import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../servicios/api.dart';
import '../servicios/auth.dart';
import 'home.dart';

const baseUrl = "http://10.0.2.2"; // Emulador Android local

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController rutController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  bool cargando = false;
  String? error;

  @override
  void dispose() {
    rutController.dispose();
    apellidoController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    final rut = rutController.text.trim();
    final apellido = apellidoController.text.trim().toLowerCase();

    if (rut.isEmpty || apellido.isEmpty) {
      if (!mounted) return;
      setState(() => error = 'Ingresa RUT y Apellido');
      return;
    }

    if (!mounted) return;
    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final api = ApiService();
      final medicos = await api.getMedicos();

      final medico = medicos.firstWhere(
        (m) =>
            (m['rut']?.toString().trim() == rut) &&
            (m['apellido']?.toString().toLowerCase().trim() == apellido),
        orElse: () => null,
      );

      if (medico != null) {
        await AuthService().saveSession(medico);

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeView()),
        );
      } else {
        if (!mounted) return;
        setState(() => error = 'RUT o apellido incorrecto');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => error = 'Error al iniciar sesión: $e');
    } finally {
      if (!mounted) return;
      setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Inicio de Sesión',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF03A9F4),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: rutController,
                  decoration: const InputDecoration(
                    labelText: 'RUT',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: apellidoController,
                  decoration: const InputDecoration(
                    labelText: 'Apellido (contraseña)',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                cargando
                    ? const CircularProgressIndicator(color: Color(0xFF03A9F4))
                    : ElevatedButton(
                        onPressed: _iniciarSesion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF03A9F4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 14,
                          ),
                        ),
                        child: const Text(
                          'Ingresar',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                if (error != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
