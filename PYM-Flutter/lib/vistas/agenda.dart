import 'package:flutter/material.dart';
import '../servicios/stream.dart';

class AgendaView extends StatefulWidget {
  const AgendaView({super.key});

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  final StreamService _streamService = StreamService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda de Consultas'),
        backgroundColor: const Color(0xFF03A9F4),
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: _streamService.getDataStream(port: 3002),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar consultas: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final consultas = snapshot.data ?? [];

          if (consultas.isEmpty) {
            return const Center(
              child: Text(
                'No hay consultas registradas',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: consultas.length,
            itemBuilder: (context, index) {
              final consulta = consultas[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF03A9F4),
                    child: Icon(Icons.calendar_today, color: Colors.white),
                  ),
                  title: Text(
                    consulta['nombre_paciente'] ?? 'Consulta sin paciente',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Fecha: ${consulta['fecha'] ?? 'Desconocida'}\n'
                    'Médico: ${consulta['medico'] ?? 'Sin asignar'}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
