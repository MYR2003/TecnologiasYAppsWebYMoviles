import 'package:flutter/material.dart';
import '../servicios/stream.dart';
import 'paciente_detalle.dart';

class PacientesView extends StatefulWidget {
  const PacientesView({super.key});

  @override
  State<PacientesView> createState() => _PacientesViewState();
}

class _PacientesViewState extends State<PacientesView> {
  final StreamService _streamService = StreamService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        backgroundColor: const Color(0xFF03A9F4),
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: _streamService.getDataStream(port: 3016),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final pacientes = snapshot.data ?? [];

          if (pacientes.isEmpty) {
            return const Center(
              child: Text(
                'No hay pacientes registrados',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: pacientes.length,
            itemBuilder: (context, index) {
              final paciente = pacientes[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF03A9F4),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    paciente['nombre'] ?? 'Paciente sin nombre',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('RUT: ${paciente['rut'] ?? 'Desconocido'}'),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetallePacienteScreen(paciente: paciente),
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
