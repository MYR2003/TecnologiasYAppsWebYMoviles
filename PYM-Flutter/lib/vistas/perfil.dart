import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../servicios/auth.dart';
import 'login.dart';
import '../servicios/geolocalizacion.dart';

const baseUrl = "http://10.0.2.2";

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  Map<String, dynamic>? medico;
  bool cargando = true;

  // Servicio de geo
  final geoService = GeolocalizacionService();
  String ubicacionTexto = '';

  @override
  void initState() {
    super.initState();
    _cargarMedicoSesion();
    _cargarUbicacion();
  }

  // Cargo Ubicación
  Future<void> _cargarUbicacion() async {
    try {
      final data = await geoService.obtenerUbicacion();
      if (data != null) {
        setState(() {
          ubicacionTexto = '${data['city']}, ${data['country']}';
        });
      }
    } catch (e) {
      print('Error al obtener ubicación: $e');
    }
  }

  Future<void> _cargarMedicoSesion() async {
    try {
      final auth = AuthService();
      final medicoGuardado = await auth.getSession();

      if (medicoGuardado == null) {
        final res = await http.get(Uri.parse('$baseUrl:3015/'));
        if (res.statusCode == 200) {
          final data = jsonDecode(utf8.decode(res.bodyBytes));
          setState(() {
            medico = data.first;
            cargando = false;
          });
        }
      } else {
        setState(() {
          medico = medicoGuardado;
          cargando = false;
        });
      }
    } catch (e) {
      print("Error al cargar médico: $e");
      setState(() {
        cargando = false;
      });
    }
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Perfil Médico'),
        backgroundColor: const Color(0xFF03A9F4),
        elevation: 0,
      ),
      body: cargando
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF03A9F4)))
          : medico == null
              ? const Center(child: Text("No se encontró el perfil"))
              : _contenidoPerfil(),
    );
  }

  Widget _contenidoPerfil() {
    final nombreLimpio = medico!['nombre']
        ?.toString()
        .replaceAll(RegExp(r'^[Dd][Rr][Aa]?\.\s*'), '')
        .trim();
    final inicial = nombreLimpio != null && nombreLimpio.isNotEmpty
        ? nombreLimpio[0].toUpperCase()
        : '?';

    final fecha = medico!['fechanacimiento']?.toString() ?? '';
    final fechaLimpia =
        fecha.contains('T') ? fecha.split('T').first : 'No disponible';

    const especialidades = {
      1: 'Medicina General',
      2: 'Pediatría',
      3: 'Cardiología',
      4: 'Traumatología',
    };
    final especialidad =
        especialidades[medico!['idespecialidad']] ?? 'Sin asignar';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFF03A9F4),
            child: Text(
              inicial,
              style: const TextStyle(fontSize: 36, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$nombreLimpio ${medico!['apellido']}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hospital Padre Hurtado',
            style: TextStyle(color: Color(0xFF607D8B)),
          ),
          const SizedBox(height: 20),
          _infoCard(Icons.badge, 'Especialidad', especialidad),
          _infoCard(Icons.perm_identity, 'RUT', medico!['rut'] ?? 'N/A'),
          _infoCard(Icons.cake, 'Nacimiento', fechaLimpia),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: _cerrarSesion,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          // Ubicación
          if (ubicacionTexto.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Ubicación actual: $ubicacionTexto',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoCard(IconData icon, String titulo, String valor) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF03A9F4)),
        title: Text(titulo),
        subtitle: Text(valor),
      ),
    );
  }
}
