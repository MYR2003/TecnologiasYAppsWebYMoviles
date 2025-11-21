import 'package:flutter/material.dart';
import '../modelos/consulta.dart';
import '../servicios/api.dart';
import '../servicios/auth.dart';

class ConsultaFormScreen extends StatefulWidget {
  const ConsultaFormScreen({super.key, this.consulta});

  final Consulta? consulta;

  @override
  State<ConsultaFormScreen> createState() => _ConsultaFormScreenState();
}

class _ConsultaFormScreenState extends State<ConsultaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();

  int? _pacienteId;
  int? _medicoId;
  DateTime? _fecha;
  String? _medicoNombre;

  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _motivoController = TextEditingController();
  final TextEditingController _observacionesController =
      TextEditingController();
  final TextEditingController _duracionController = TextEditingController();

  late Future<List<dynamic>> _pacientesFuture;

  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final consulta = widget.consulta;
    _pacienteId = consulta?.idpersona;
    _medicoId = consulta?.idmedico;
    _motivoController.text = consulta?.motivo ?? '';
    _observacionesController.text = consulta?.observaciones ?? '';
    if (consulta?.duracionminutos != null) {
      _duracionController.text = consulta!.duracionminutos.toString();
    }

    if (consulta?.fecha.isNotEmpty == true) {
      try {
        _fecha = DateTime.parse(consulta!.fecha);
        _fechaController.text = _formatearFecha(_fecha!);
      } catch (_) {}
    }

    _pacientesFuture = _apiService.getPacientes();
    _cargarMedicoSesion();
  }

  Future<void> _cargarMedicoSesion() async {
    try {
      final session = await _authService.getSession();
      if (!mounted) return;
      final idMedicoSesion = session?['idmedico'] as int?;
      final nombre = (session?['nombre'] ?? '').toString();
      final apellido = (session?['apellido'] ?? '').toString();
      final full = '$nombre $apellido'.trim();
      setState(() {
        _medicoId = _medicoId ?? idMedicoSesion;
        _medicoNombre = full.isEmpty ? 'Medico PYM' : full;
      });
    } catch (_) {
      // Si no hay sesion, mantenemos valores nulos y el snackbar avisará
    }
  }

  @override
  void dispose() {
    _fechaController.dispose();
    _motivoController.dispose();
    _observacionesController.dispose();
    _duracionController.dispose();
    super.dispose();
  }

  String _formatearFecha(DateTime fecha) {
    final fechaStr =
        '${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}';
    final horaStr =
        '${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
    return '$fechaStr $horaStr';
  }

  Future<void> _seleccionarFechaHora() async {
    final hoy = DateTime.now();
    final fechaInicial = _fecha ?? hoy;

    final fecha = await showDatePicker(
      context: context,
      firstDate: DateTime(hoy.year - 1),
      lastDate: DateTime(hoy.year + 2),
      initialDate: fechaInicial,
    );

    if (fecha == null) return;

    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(fechaInicial),
    );

    final fechaHora = DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
      hora?.hour ?? 0,
      hora?.minute ?? 0,
    );

    setState(() {
      _fecha = fechaHora;
      _fechaController.text = _formatearFecha(fechaHora);
    });
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_pacienteId == null || _medicoId == null || _fecha == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona paciente y fecha. Inicia sesion como medico.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _guardando = true;
    });

    final data = {
      'idpersona': _pacienteId,
      'idmedico': _medicoId,
      'fecha': _fecha!.toIso8601String(),
      'motivo': _motivoController.text.trim().isEmpty
          ? null
          : _motivoController.text.trim(),
      'duracionminutos': int.tryParse(_duracionController.text.trim()),
      'observaciones': _observacionesController.text.trim().isEmpty
          ? null
          : _observacionesController.text.trim(),
    };

    Map<String, dynamic> resultado;
    if (widget.consulta == null) {
      resultado = await _apiService.crearConsulta(data);
    } else {
      resultado = await _apiService.actualizarConsulta(
          widget.consulta!.idconsulta!, data);
    }

    if (!mounted) return;
    setState(() {
      _guardando = false;
    });

    final esOk = resultado['success'] == true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            resultado['message'] ?? (esOk ? 'Guardado con exito' : 'Error al guardar')),
        backgroundColor: esOk ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (esOk) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.consulta != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FF),
      appBar: AppBar(
        title: Text(esEdicion ? 'Editar consulta' : 'Nueva consulta'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0EA5E9),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSelectorPacientes(),
              const SizedBox(height: 16),
              _buildMedicoInfo(),
              const SizedBox(height: 16),
              _buildFechaField(),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _motivoController,
                label: 'Motivo',
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _duracionController,
                label: 'Duracion (minutos)',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _observacionesController,
                label: 'Observaciones',
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _guardando ? null : _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0EA5E9),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: Color(0xFF0EA5E9), width: 1.5),
                  ),
                  elevation: 2,
                ),
                icon: _guardando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  esEdicion ? 'Actualizar' : 'Crear',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectorPacientes() {
    return FutureBuilder<List<dynamic>>(
      future: _pacientesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final pacientes = snapshot.data ?? [];
        return DropdownButtonFormField<int>(
          value: _pacienteId,
          decoration: _inputDecoration('Paciente'),
          items: pacientes.map<DropdownMenuItem<int>>((p) {
            final pac = p as Map<String, dynamic>;
            final nombre =
                '${(pac['nombre'] ?? '').toString()} ${(pac['apellido'] ?? '').toString()}';
            final rut = (pac['rut'] ?? '').toString();
            final label = rut.isNotEmpty ? '$nombre - $rut' : nombre;
            return DropdownMenuItem<int>(
              value: pac['idpersona'],
              child: Text(label.trim().isEmpty ? 'Paciente ${pac['idpersona']}' : label),
            );
          }).toList(),
          onChanged: (value) => setState(() => _pacienteId = value),
          validator: (value) =>
              value == null ? 'Selecciona un paciente' : null,
        );
      },
    );
  }

  Widget _buildMedicoInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          const Icon(Icons.medical_services_outlined, color: Color(0xFF0EA5E9)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Medico asignado',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  _medicoNombre ?? 'Sin sesion de medico',
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
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


  Widget _buildFechaField() {
    return TextFormField(
      controller: _fechaController,
      readOnly: true,
      decoration: _inputDecoration('Fecha y hora').copyWith(
        suffixIcon: IconButton(
          icon: const Icon(Icons.edit_calendar),
          onPressed: _seleccionarFechaHora,
        ),
      ),
      onTap: _seleccionarFechaHora,
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Selecciona fecha y hora' : null,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
    );
  }
}
