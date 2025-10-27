import 'package:flutter/material.dart';

class DetallePacienteScreen extends StatelessWidget {
  final Map<String, dynamic> paciente;

  const DetallePacienteScreen({super.key, required this.paciente});

  @override
  Widget build(BuildContext context) {
    final nombre = paciente['nombre'] ?? 'Sin nombre';
    final rut = paciente['rut'] ?? 'Desconocido';
    final edad = paciente['edad']?.toString() ?? 'N/A';
    final diagnostico = paciente['diagnostico'] ?? 'No especificado';
    final fechaIngreso = paciente['fecha_ingreso'] ?? 'No disponible';
    final sexo = paciente['sexo'] ?? 'No informado';
    final telefono = paciente['telefono'] ?? 'No registrado';
    final direccion = paciente['direccion'] ?? 'No registrada';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del Paciente'),
        backgroundColor: const Color(0xFF03A9F4),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado con ícono y nombre
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFF03A9F4),
                  child: Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    nombre,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Datos principales
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Información básica',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF03A9F4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _infoRow(Icons.badge, 'RUT', rut),
                    _infoRow(Icons.cake, 'Edad', edad),
                    _infoRow(Icons.wc, 'Sexo', sexo),
                    _infoRow(Icons.phone, 'Teléfono', telefono),
                    _infoRow(Icons.home, 'Dirección', direccion),
                    _infoRow(Icons.calendar_today, 'Fecha de ingreso', fechaIngreso),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Diagnóstico o motivo de atención
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Diagnóstico',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF03A9F4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      diagnostico,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Botón de volver
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF03A9F4),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700], size: 20),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
