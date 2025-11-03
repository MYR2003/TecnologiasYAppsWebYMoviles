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
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF4F9FF),
      appBar: AppBar(
        title: const Text('Pacientes PYM'),
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
          child: StreamBuilder<List<dynamic>>(
            stream: _streamService.getDataStream(port: 3016),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (snapshot.hasError) {
                return Center(
                  child: _FeedbackCard(
                    icon: Icons.error_outline,
                    title: 'No pudimos cargar los pacientes',
                    message: snapshot.error.toString(),
                  ),
                );
              }

              final pacientes = snapshot.data ?? [];

              if (pacientes.isEmpty) {
                return const Center(
                  child: _FeedbackCard(
                    icon: Icons.search_off,
                    title: 'Aún no registras pacientes',
                    message: 'Cuando se agreguen pacientes aparecerán aquí.',
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                    child: _SummaryHeader(total: pacientes.length),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x33027BB7),
                            offset: Offset(0, -2),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                        itemCount: pacientes.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 18),
                        itemBuilder: (context, index) {
                          final paciente =
                              pacientes[index] as Map<String, dynamic>;
                          return _PacienteCard(
                            paciente: paciente,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetallePacienteScreen(paciente: paciente),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.18),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: const Icon(Icons.people_alt, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pacientes registrados',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$total personas activas en PYM',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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

class _PacienteCard extends StatelessWidget {
  const _PacienteCard({required this.paciente, required this.onTap});

  final Map<String, dynamic> paciente;
  final VoidCallback onTap;

  String get _nombre =>
      (paciente['nombre'] ?? 'Paciente sin nombre').toString();

  String get _rut => (paciente['rut'] ?? 'Desconocido').toString();

  String get _sistemaSalud =>
      (paciente['sistema_salud'] ?? 'Sistema no definido').toString();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFFF0F9FF), Color(0xFFECFEFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A0F172A),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Avatar(nombre: _nombre),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _nombre,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Color(0xFF0EA5E9)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _InfoChip(
                        icon: Icons.badge_outlined,
                        label: 'RUT',
                        value: _rut,
                      ),
                      _InfoChip(
                        icon: Icons.health_and_safety_outlined,
                        label: 'Sistema',
                        value: _sistemaSalud,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.nombre});

  final String nombre;

  @override
  Widget build(BuildContext context) {
    final iniciales = nombre.isNotEmpty
        ? nombre
              .trim()
              .split(RegExp(r"\s+"))
              .take(2)
              .map((p) => p[0])
              .join()
              .toUpperCase()
        : 'PY';
    return Container(
      height: 58,
      width: 58,
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
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFE0F2FE),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF0284C7), size: 18),
          const SizedBox(width: 8),
          Text(
            '$label · $value',
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 42),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
