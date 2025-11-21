import 'package:flutter/material.dart';
import '../servicios/api.dart';
import '../modelos/consulta.dart';
import 'consulta_form.dart';
import '../servicios/auth.dart';

class AgendaView extends StatefulWidget {
  const AgendaView({super.key});

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  final ApiService _apiService = ApiService();
  bool _isProcessing = false;
  bool _cargandoMedico = true;
  int? _medicoId;
  int _limit = 20;
  int _offset = 0;
  int _total = 0;
  late Future<Map<String, dynamic>> _futureConsultas;
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _searchQueryNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _cargarMedico();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchQueryNotifier.dispose();
    super.dispose();
  }

  Future<void> _cargarMedico() async {
    final auth = AuthService();
    final session = await auth.getSession();
    if (!mounted) return;
    setState(() {
      _medicoId = session?['idmedico'] as int?;
      _cargandoMedico = false;
      _futureConsultas = _fetchConsultas();
    });
  }

  List<Consulta> _mapearConsultas(List<dynamic> data) {
    return data
        .map((item) => Consulta.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  List<Consulta> _filtrarConsultas(List<Consulta> consultas, String query) {
    if (query.trim().isEmpty) return consultas;
    final q = query.toLowerCase().trim();
    return consultas.where((c) {
      return (c.nombrePaciente ?? '').toLowerCase().contains(q) ||
          (c.nombreMedico ?? '').toLowerCase().contains(q) ||
          (c.motivo ?? '').toLowerCase().contains(q);
    }).toList();
  }

  Future<Map<String, dynamic>> _fetchConsultas() {
    if (_medicoId == null) {
      return Future.value({
        'data': <dynamic>[],
        'total': 0,
        'limit': _limit,
        'offset': _offset,
      });
    }
    return _apiService.getConsultasPaginated(
      limit: _limit,
      offset: _offset,
      idMedico: _medicoId,
    );
  }

  void _irAPagina(int pagina) {
    final totalPaginas = _total == 0 ? 1 : (_total + _limit - 1) ~/ _limit;
    final page = pagina.clamp(1, totalPaginas == 0 ? 1 : totalPaginas);
    setState(() {
      _offset = (page - 1) * _limit;
      _futureConsultas = _fetchConsultas();
    });
  }

  Future<void> _abrirFormulario({Consulta? consulta}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ConsultaFormScreen(consulta: consulta),
      ),
    );
    if (result == true && mounted) {
      setState(() {
        _futureConsultas = _fetchConsultas();
      });
    }
  }

  Future<void> _eliminarConsulta(Consulta consulta) async {
    if (_isProcessing) return;
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar consulta'),
        content: Text(
          'Eliminar la consulta de ${consulta.nombrePaciente ?? 'Paciente'} del ${_formatearFecha(consulta.fecha)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          )
        ],
      ),
    );

    if (confirmar != true) return;

    setState(() {
      _isProcessing = true;
    });

    final resultado =
        await _apiService.eliminarConsulta(consulta.idconsulta ?? -1);

    if (!mounted) return;
    setState(() {
      _isProcessing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(resultado['message'] ??
            (resultado['success'] == true
                ? 'Consulta eliminada'
                : 'No se pudo eliminar')),
        backgroundColor:
            resultado['success'] == true ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (resultado['success'] == true && mounted) {
      setState(() {
        _futureConsultas = _fetchConsultas();
      });
    }
  }

  String _formatearFecha(String fecha) {
    try {
      final date = DateTime.parse(fecha);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return fecha;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargandoMedico) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_medicoId == null) {
      return const Scaffold(
        body: Center(
          child: Text('No hay sesion de medico. Inicia sesion para ver tu agenda.'),
        ),
      );
    }

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
          child: FutureBuilder<Map<String, dynamic>>(
            future: _futureConsultas,
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
                  message: 'Intenta actualizar o verifica la conexion.',
                );
              }

              final resp = snapshot.data ?? {};
              final lista = _mapearConsultas(resp['data'] as List<dynamic>? ?? []);
              _total = (resp['total'] as int?) ?? lista.length;
              _limit = (resp['limit'] as int?) ?? _limit;
              _offset = (resp['offset'] as int?) ?? _offset;
              final totalPaginas = _total == 0 ? 1 : (_total + _limit - 1) ~/ _limit;
              final paginaActual = _total == 0 ? 1 : (_offset ~/ _limit) + 1;

              if (lista.isEmpty) {
                return const _AgendaFeedback(
                  icon: Icons.event_busy,
                  title: 'Agenda libre por ahora',
                  message: 'Cuando se agenden nuevas consultas las veras aqui.',
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    child: _AgendaHeader(total: _total),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: _SearchBar(
                      controller: _searchController,
                      onChanged: (value) => _searchQueryNotifier.value = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isProcessing ? null : () => _abrirFormulario(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0EA5E9),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Color(0xFF0EA5E9), width: 1.5),
                            ),
                            elevation: 2,
                          ),
                          icon: const Icon(Icons.add),
                          label: const Text(
                            'Nueva consulta',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
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
                      child: Column(
                        children: [
                          Expanded(
                            child: ValueListenableBuilder<String>(
                              valueListenable: _searchQueryNotifier,
                              builder: (context, search, _) {
                                final filtradas = _filtrarConsultas(lista, search);
                                return ListView.separated(
                                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                                  itemBuilder: (context, index) {
                                    final consulta = filtradas[index];
                                    return _ConsultaCard(
                                      consulta: consulta,
                                      onEdit: () => _abrirFormulario(consulta: consulta),
                                      onDelete: () => _eliminarConsulta(consulta),
                                    );
                                  },
                                  separatorBuilder: (_, __) => const SizedBox(height: 18),
                                  itemCount: filtradas.length,
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            child: _PaginationBar(
                              currentPage: paginaActual,
                              totalPages: totalPaginas,
                              onFirst: () => _irAPagina(1),
                              onPrev: () => _irAPagina(paginaActual - 1),
                              onNext: () => _irAPagina(paginaActual + 1),
                              onLast: () => _irAPagina(totalPaginas),
                            ),
                          ),
                        ],
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
                  '$total atenciones proximas',
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
  const _ConsultaCard({
    required this.consulta,
    required this.onEdit,
    required this.onDelete,
  });

  final Consulta consulta;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  String get _paciente =>
      (consulta.nombrePaciente ?? 'Paciente sin nombre').toString();

  String get _medico => (consulta.nombreMedico ?? 'Sin asignar').toString();

  String get _fecha => (consulta.fecha).toString();

  String get _motivo =>
      (consulta.motivo ?? consulta.observaciones ?? 'Sin motivo').toString();

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
                label: 'Motivo',
                value: _motivo,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: onEdit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.edit, size: 18),
                label: const Text(
                  'Editar',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: onDelete,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.delete, size: 18),
                label: const Text(
                  'Eliminar',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
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
              '$label - $value',
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

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({
    required this.currentPage,
    required this.totalPages,
    required this.onFirst,
    required this.onPrev,
    required this.onNext,
    required this.onLast,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback onFirst;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.first_page),
          onPressed: currentPage > 1 ? onFirst : null,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: currentPage > 1 ? onPrev : null,
        ),
        Text('Pagina $currentPage de $totalPages'),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: currentPage < totalPages ? onNext : null,
        ),
        IconButton(
          icon: const Icon(Icons.last_page),
          onPressed: currentPage < totalPages ? onLast : null,
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, child) {
          return TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'Buscar por paciente, medico o motivo...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF0EA5E9)),
              suffixIcon: value.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        controller.clear();
                        onChanged('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          );
        },
      ),
    );
  }
}
