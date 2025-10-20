import 'package:flutter/material.dart';
import '../servicios/stream.dart';
import 'paciente_detalle.dart';

class PacientesView extends StatelessWidget {
  final StreamService _streamService = StreamService();

  PacientesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        backgroundColor: Colors.teal,
        elevation: 2,
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: StreamBuilder<List<dynamic>>(
        stream: _streamService.streamPacientes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No hay pacientes disponibles",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          final pacientes = snapshot.data!;

          return ListView.builder(
            itemCount: pacientes.length,
            itemBuilder: (context, index) {
              final p = pacientes[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.shade400,
                    child: Text(
                      (p['nombre'] ?? '?')[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text('${p['nombre']} ${p['apellido']}'),
                  subtitle: Text('RUT: ${p['rut'] ?? 'No disponible'}'),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DetallePacienteScreen(paciente: p),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
