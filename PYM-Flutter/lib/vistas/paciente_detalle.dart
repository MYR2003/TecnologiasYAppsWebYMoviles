import 'package:flutter/material.dart';

class DetallePacienteScreen extends StatelessWidget {
  const DetallePacienteScreen({super.key, required this.paciente});

  final Map<String, dynamic> paciente;

  @override
  Widget build(BuildContext context) {
    final nombre = (paciente['nombre'] ?? 'Paciente sin nombre').toString();
    final rut = (paciente['rut'] ?? 'Desconocido').toString();
    final edad = (paciente['edad'] ?? 'N/A').toString();
    final diagnostico = (paciente['diagnostico'] ?? 'No especificado')
        .toString();
    final fechaIngreso = (paciente['fecha_ingreso'] ?? 'No disponible')
        .toString();
    final sexo = (paciente['sexo'] ?? 'No informado').toString();
    final telefono = (paciente['telefono'] ?? 'No registrado').toString();
    final direccion = (paciente['direccion'] ?? 'No registrada').toString();
    final sistema = (paciente['sistema_salud'] ?? 'Sin información').toString();

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
                _HeroHeader(nombre: nombre, sistema: sistema),
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
                      icon: Icons.wc_outlined,
                      label: 'Sexo',
                      value: sexo,
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
                      label: 'Dirección',
                      value: direccion,
                    ),
                    _InfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Ingreso a PYM',
                      value: fechaIngreso,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _InfoSection(
                  title: 'Notas clínicas',
                  icon: Icons.insights_outlined,
                  children: [_DiagnosisCard(diagnostico: diagnostico)],
                ),
                const SizedBox(height: 24),
                Align(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0284C7),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 10,
                      shadowColor: const Color(0x33027BB7),
                    ),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    label: const Text(
                      'Volver a pacientes',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
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
  const _HeroHeader({required this.nombre, required this.sistema});

  final String nombre;
  final String sistema;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  sistema,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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

class _DiagnosisCard extends StatelessWidget {
  const _DiagnosisCard({required this.diagnostico});

  final String diagnostico;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFE0F2FE), Color(0xFFEFF6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.stacked_line_chart, color: Color(0xFF0284C7)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              diagnostico,
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
