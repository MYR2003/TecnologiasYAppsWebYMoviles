import 'package:flutter/material.dart';
import '../servicios/api.dart';
import '../modelos/paciente.dart';
import 'paciente_detalle.dart';
import 'paciente_form.dart';

class PacientesView extends StatefulWidget {
  const PacientesView({super.key});

  @override
  State<PacientesView> createState() => _PacientesViewState();
}

class _PacientesViewState extends State<PacientesView> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _searchQueryNotifier = ValueNotifier<String>('');
  late Future<Map<String, dynamic>> _futurePacientes;

  int _limit = 20;
  int _offset = 0;
  int _total = 0;

  @override
  void initState() {
    super.initState();
    _futurePacientes = _fetchPacientes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchQueryNotifier.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _filtrarPacientes(
      List<dynamic> pacientes, String query) {
    if (query.isEmpty) {
      return pacientes.cast<Map<String, dynamic>>();
    }

    final queryLower = query.toLowerCase().trim();
    final palabrasBuscadas =
        queryLower.split(' ').where((p) => p.isNotEmpty).toList();

    final resultados = pacientes.where((p) {
      final paciente = p as Map<String, dynamic>;
      final nombre = (paciente['nombre'] ?? '').toString().toLowerCase();
      final apellido = (paciente['apellido'] ?? '').toString().toLowerCase();
      final rut = (paciente['rut'] ?? '').toString().toLowerCase();

      if (palabrasBuscadas.length == 1 && rut.contains(queryLower)) {
        return true;
      }

      if (palabrasBuscadas.length > 1) {
        return palabrasBuscadas
            .every((palabra) => nombre.contains(palabra) || apellido.contains(palabra));
      }

      return nombre.contains(queryLower) ||
          apellido.contains(queryLower) ||
          rut.contains(queryLower);
    }).cast<Map<String, dynamic>>().toList();

    resultados.sort((a, b) {
      final nombreA = (a['nombre'] ?? '').toString().toLowerCase();
      final apellidoA = (a['apellido'] ?? '').toString().toLowerCase();
      final nombreCompletoA = '$nombreA $apellidoA';

      final nombreB = (b['nombre'] ?? '').toString().toLowerCase();
      final apellidoB = (b['apellido'] ?? '').toString().toLowerCase();
      final nombreCompletoB = '$nombreB $apellidoB';

      final exactaA = nombreCompletoA.contains(queryLower);
      final exactaB = nombreCompletoB.contains(queryLower);

      if (exactaA && !exactaB) return -1;
      if (!exactaA && exactaB) return 1;

      return nombreCompletoA.compareTo(nombreCompletoB);
    });

    return resultados;
  }

  Future<void> _navegarAFormulario({Paciente? paciente}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => PacienteFormScreen(paciente: paciente),
      ),
    );

    if (result == true && mounted) {
      setState(() {
        _futurePacientes = _fetchPacientes();
      });
    }
  }

  Future<Map<String, dynamic>> _fetchPacientes() {
    return _apiService.getPacientesPaginated(limit: _limit, offset: _offset);
  }

  void _irAPagina(int pagina) {
    final totalPaginas = _total == 0 ? 1 : (_total + _limit - 1) ~/ _limit;
    final page = pagina.clamp(1, totalPaginas == 0 ? 1 : totalPaginas);
    setState(() {
      _offset = (page - 1) * _limit;
      _futurePacientes = _fetchPacientes();
    });
  }

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
          child: FutureBuilder<Map<String, dynamic>>(
            future: _futurePacientes,
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

              final resp = snapshot.data ?? {};
              final pacientes = (resp['data'] as List<dynamic>? ?? []);
              _total = (resp['total'] as int?) ?? pacientes.length;
              _limit = (resp['limit'] as int?) ?? _limit;
              _offset = (resp['offset'] as int?) ?? _offset;
              final totalPaginas = _total == 0 ? 1 : (_total + _limit - 1) ~/ _limit;
              final paginaActual = _total == 0 ? 1 : (_offset ~/ _limit) + 1;

              if (pacientes.isEmpty) {
                return const Center(
                  child: _FeedbackCard(
                    icon: Icons.search_off,
                    title: 'Aun no registras pacientes',
                    message: 'Cuando se agreguen pacientes apareceran aqui.',
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                    child: _SummaryHeader(total: _total),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: _SearchBar(
                      controller: _searchController,
                      onChanged: (value) {
                        _searchQueryNotifier.value = value;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _navegarAFormulario(),
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
                          icon: const Icon(Icons.person_add),
                          label: const Text(
                            'Nuevo paciente',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder<String>(
                      valueListenable: _searchQueryNotifier,
                      builder: (context, searchQuery, _) {
                        final pacientesFiltrados =
                            _filtrarPacientes(pacientes, searchQuery);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (searchQuery.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  '${pacientesFiltrados.length} resultado(s) en esta pagina',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 12),
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
                                child: pacientesFiltrados.isEmpty
                                    ? Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(32),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.search_off,
                                                size: 64,
                                                color: Colors.grey[400],
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                'No se encontraron pacientes en esta pagina',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Intenta con otro termino de busqueda',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[500],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          Expanded(
                                            child: ListView.separated(
                                              padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                                              itemCount: pacientesFiltrados.length,
                                              separatorBuilder: (_, __) =>
                                                  const SizedBox(height: 18),
                                              itemBuilder: (context, index) {
                                                final paciente = pacientesFiltrados[index];
                                                return _PacienteCard(
                                                  paciente: paciente,
                                                  onTap: () async {
                                                    final result = await Navigator.push<bool>(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            DetallePacienteScreen(
                                                                paciente: paciente),
                                                      ),
                                                    );
                                                    if (result == true && mounted) {
                                                      setState(() {
                                                        _futurePacientes = _fetchPacientes();
                                                      });
                                                    }
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
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
                  '$total pacientes en PYM',
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
  const _PacienteCard({
    required this.paciente,
    required this.onTap,
  });

  final Map<String, dynamic> paciente;
  final VoidCallback onTap;

  String get _nombreCompleto {
    final apellido = (paciente['apellido'] ?? '').toString();
    final nombre = (paciente['nombre'] ?? '').toString();
    return '$nombre $apellido'.trim();
  }

  String get _rut => (paciente['rut'] ?? 'Sin RUT').toString();

  String get _sistemaSalud =>
      (paciente['sistemadesalud'] ?? 'No especificado').toString();

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
            _Avatar(nombreCompleto: _nombreCompleto),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _nombreCompleto,
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
                        icon: Icons.local_hospital_outlined,
                        label: 'Prevision',
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
  const _Avatar({required this.nombreCompleto});

  final String nombreCompleto;

  @override
  Widget build(BuildContext context) {
    String iniciales = 'PY';

    if (nombreCompleto.isNotEmpty) {
      final palabras = nombreCompleto.trim().split(RegExp(r"\s+"));
      if (palabras.length >= 2) {
        iniciales = '${palabras[0][0]}${palabras[1][0]}'.toUpperCase();
      } else if (palabras.length == 1 && palabras[0].isNotEmpty) {
        iniciales = palabras[0][0].toUpperCase();
      }
    }

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
            '$label - $value',
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
              hintText: 'Buscar por RUT, nombre o apellido...',
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
