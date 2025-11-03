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
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF4F9FF),
      appBar: AppBar(
        title: const Text('Agenda PYM'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0EA5E9), Color(0xFF0369A1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: StreamBuilder<List<dynamic>>(
            stream: _streamService.getDataStream(port: 3002),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (snapshot.hasError) {
                return const _AgendaFeedback(
                  icon: Icons.error_outline,
                  title: 'No pudimos cargar tu agenda',
                  message: 'Intenta actualizar o verifica la conexión.',
                );
              }

              final consultas = snapshot.data ?? [];

              if (consultas.isEmpty) {
                return const _AgendaFeedback(
                  icon: Icons.event_busy,
                  title: 'Agenda libre por ahora',
                  message: 'Cuando se agenden nuevas consultas las verás aquí.',
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    child: _AgendaHeader(total: consultas.length),
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
                        itemBuilder: (context, index) {
                          final consulta =
                              consultas[index] as Map<String, dynamic>;
                          return _ConsultaCard(consulta: consulta);
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 18),
                        itemCount: consultas.length,
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

class _AgendaHeader extends StatelessWidget {
  const _AgendaHeader({required this.total});

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
            child: const Icon(
              Icons.medical_services_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Consultas programadas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$total atenciones próximas',
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

class _ConsultaCard extends StatelessWidget {
  const _ConsultaCard({required this.consulta});

  final Map<String, dynamic> consulta;

  String get _paciente =>
      (consulta['nombre_paciente'] ?? 'Paciente sin nombre').toString();

  String get _medico => (consulta['medico'] ?? 'Sin asignar').toString();

  String get _fecha => (consulta['fecha'] ?? 'Por confirmar').toString();

  String get _observacion =>
      (consulta['observacion'] ?? 'Sin observaciones').toString();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFFF8FAFC), Color(0xFFEFF6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF38BDF8), Color(0xFF0EA5E9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _paciente,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 18,
                          color: Color(0xFF0284C7),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _fecha,
                          style: const TextStyle(
                            color: Color(0xFF0369A1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              _ConsultaChip(
                icon: Icons.medical_information_outlined,
                label: 'Profesional',
                value: _medico,
              ),
              _ConsultaChip(
                icon: Icons.note_alt_outlined,
                label: 'Observación',
                value: _observacion,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ConsultaChip extends StatelessWidget {
  const _ConsultaChip({
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
          Flexible(
            child: Text(
              '$label · $value',
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AgendaFeedback extends StatelessWidget {
  const _AgendaFeedback({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
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
      ),
    );
  }
}
