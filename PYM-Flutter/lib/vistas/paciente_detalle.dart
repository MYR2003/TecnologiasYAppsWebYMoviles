import 'package:flutter/material.dart';
import '../servicios/api.dart';
import '../modelos/paciente.dart';
import 'paciente_form.dart';

class DetallePacienteScreen extends StatelessWidget {
  const DetallePacienteScreen({super.key, required this.paciente});

  final Map<String, dynamic> paciente;

  Future<void> _eliminarPaciente(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de eliminar a ${_getNombreCompleto()}?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final apiService = ApiService();
      final result = await apiService.eliminarPaciente(paciente['idpersona']);
      
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: result['success'] ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );

      if (result['success']) {
        Navigator.pop(context, true); // Retorna true para refrescar la lista
      }
    }
  }

  Future<void> _editarPaciente(BuildContext context) async {
    final pacienteObj = Paciente.fromJson(paciente);
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => PacienteFormScreen(paciente: pacienteObj),
      ),
    );

    if (result == true && context.mounted) {
      Navigator.pop(context, true); // Retorna true para refrescar la lista
    }
  }

  String _getNombreCompleto() {
    final apellido = (paciente['apellido'] ?? '').toString();
    final nombre = (paciente['nombre'] ?? '').toString();
    return '$nombre $apellido'.trim();
  }

  String _calcularEdad() {
    final fecha = paciente['fechanacimiento'];
    if (fecha == null) return 'No registrada';
    try {
      final date = DateTime.parse(fecha.toString());
      final now = DateTime.now();
      final edad = now.year - date.year - 
          ((now.month > date.month || 
            (now.month == date.month && now.day >= date.day)) ? 0 : 1);
      return '$edad años';
    } catch (e) {
      return 'No registrada';
    }
  }

  String _formatearFecha(String? fecha) {
    if (fecha == null) return 'No registrada';
    try {
      final date = DateTime.parse(fecha);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return 'No registrada';
    }
  }

  @override
  Widget build(BuildContext context) {
    final nombreCompleto = _getNombreCompleto();
    final rut = (paciente['rut'] ?? 'Sin RUT').toString();
    final edad = _calcularEdad();
    final fechaNacimiento = _formatearFecha(paciente['fechanacimiento']?.toString());
    final sistemaSalud = (paciente['sistemadesalud'] ?? 'No especificado').toString();
    final telefono = (paciente['telefono'] ?? 'No registrado').toString();
    final domicilio = (paciente['domicilio'] ?? 'No registrado').toString();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF4F9FF),
      appBar: AppBar(
        title: const Text('Ficha del Paciente'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeroHeader(nombre: nombreCompleto),
                const SizedBox(height: 24),
                _InfoSection(
                  title: 'Datos personales',
                  icon: Icons.badge_outlined,
                  children: [
                    _InfoRow(icon: Icons.badge, label: 'RUT', value: rut),
                    _InfoRow(
                      icon: Icons.cake_outlined,
                      label: 'Edad',
                      value: edad,
                    ),
                    _InfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Fecha de nacimiento',
                      value: fechaNacimiento,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _InfoSection(
                  title: 'Sistema de salud',
                  icon: Icons.local_hospital_outlined,
                  children: [
                    _InfoRow(
                      icon: Icons.medical_services_outlined,
                      label: 'Sistema',
                      value: sistemaSalud,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _InfoSection(
                  title: 'Contacto y dirección',
                  icon: Icons.contact_phone_outlined,
                  children: [
                    _InfoRow(
                      icon: Icons.phone_outlined,
                      label: 'Teléfono',
                      value: telefono,
                    ),
                    _InfoRow(
                      icon: Icons.home_outlined,
                      label: 'Domicilio',
                      value: domicilio,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0EA5E9),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () => _editarPaciente(context),
                        icon: const Icon(Icons.edit),
                        label: const Text(
                          'Editar',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () => _eliminarPaciente(context),
                        icon: const Icon(Icons.delete),
                        label: const Text(
                          'Eliminar',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.nombre});

  final String nombre;

  @override
  Widget build(BuildContext context) {
    final iniciales = nombre.isNotEmpty
        ? nombre
              .trim()
              .split(RegExp(r'\s+'))
              .take(2)
              .map((e) => e[0])
              .join()
              .toUpperCase()
        : 'PY';

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A0F172A),
            offset: Offset(0, 12),
            blurRadius: 24,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF38BDF8), Color(0xFF0EA5E9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              iniciales,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              nombre,
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF0284C7)),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0EA5E9), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
