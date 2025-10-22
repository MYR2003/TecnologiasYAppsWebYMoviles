import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../servicios/auth.dart';
import 'home.dart';

const baseUrl = "http://10.0.2.2";

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

  Future<void> _login() async {
    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final res = await http.get(Uri.parse('$baseUrl:3015/'));

      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));

        // Buscar médico por rut y apellido
        final medico = data.firstWhere(
          (m) =>
              (m['rut']?.toString().trim() == rutController.text.trim()) &&
              (m['apellido']?.toString().toLowerCase().trim() ==
                  apellidoController.text.toLowerCase().trim()),
          orElse: () => null,
        );

        if (medico != null) {
          final auth = AuthService();
          await auth.saveSession(medico);

          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeView()),
          );
        } else {
          setState(() => error = 'RUT o apellido incorrecto');
        }
      } else {
        setState(() => error = 'Error al conectar con el servidor');
      }
    } catch (e) {
      setState(() => error = 'Error al iniciar sesión: $e');
    } finally {
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
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF03A9F4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 14),
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
    );
  }
}
