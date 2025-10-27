import 'package:flutter/material.dart';
import '../servicios/auth.dart';
import 'login.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  Map<String, dynamic>? medico;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  Future<void> _cargarPerfil() async {
    final auth = AuthService();
    final session = await auth.getSession();

    if (!mounted) return;
    setState(() {
      medico = session;
      cargando = false;
    });
  }

  Future<void> _cerrarSesion() async {
    final auth = AuthService();
    await auth.clearSession();

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginView()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (medico == null) {
      return const Scaffold(
        body: Center(child: Text('No hay sesión activa')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil del Médico'),
        backgroundColor: const Color(0xFF03A9F4),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _cerrarSesion,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Información del Médico',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text('Nombre: ${medico?['nombre'] ?? 'No disponible'}'),
                Text('Especialidad: ${medico?['especialidad'] ?? 'Sin datos'}'),
                Text('RUT: ${medico?['rut'] ?? 'No disponible'}'),
                Text('Correo: ${medico?['correo'] ?? 'No disponible'}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
