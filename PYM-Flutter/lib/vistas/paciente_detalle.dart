import 'package:flutter/material.dart';

class DetallePacienteScreen extends StatefulWidget {
  final Map<String, dynamic> paciente;

  const DetallePacienteScreen({super.key, required this.paciente});

  @override
  State<DetallePacienteScreen> createState() => _DetallePacienteScreenState();
}

class _DetallePacienteScreenState extends State<DetallePacienteScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.paciente;

    return Scaffold(
      appBar: AppBar(
        title: Text('${p['nombre']} ${p['apellido']}'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Resumen'),
            Tab(text: 'Alergias'),
            Tab(text: 'Contactos'),
            Tab(text: 'Diagnósticos'),
            Tab(text: 'Exámenes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildResumen(p),
          _buildAlergias(),
          _buildContactos(),
          _buildDiagnosticos(),
          _buildExamenes(),
        ],
      ),
    );
  }

  Widget _buildResumen(Map<String, dynamic> p) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Icon(Icons.person, size: 100, color: Colors.teal),
        const SizedBox(height: 16),
        Text('Nombre: ${p['nombre']} ${p['apellido']}'),
        Text('RUT: ${p['rut']}'),
        Text('Fecha de nacimiento: ${p['fechanacimiento'] ?? 'No disponible'}'),
        Text('Sistema de salud: ${p['sistemadesalud'] ?? 'No indicado'}'),
        Text('Teléfono: ${p['telefono'] ?? 'No registrado'}'),
        Text('Domicilio: ${p['domicilio'] ?? 'No registrado'}'),
      ],
    );
  }

  Widget _buildAlergias() => _emptyState('Sin alergias registradas');
  Widget _buildContactos() => _emptyState('Sin contactos de emergencia');
  Widget _buildDiagnosticos() => _emptyState('Sin diagnósticos registrados');
  Widget _buildExamenes() => _emptyState('Sin exámenes disponibles');

  Widget _emptyState(String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, color: Colors.grey, size: 50),
          const SizedBox(height: 8),
          Text(text, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
