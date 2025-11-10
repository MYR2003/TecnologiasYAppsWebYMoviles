import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../servicios/api.dart';
import '../modelos/paciente.dart';

class PacienteFormScreen extends StatefulWidget {
  final Paciente? paciente; // Si es null, es crear, si no es editar

  const PacienteFormScreen({super.key, this.paciente});

  @override
  State<PacienteFormScreen> createState() => _PacienteFormScreenState();
}

class _PacienteFormScreenState extends State<PacienteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  // Controladores de texto
  late final TextEditingController _nombreController;
  late final TextEditingController _apellidoController;
  late final TextEditingController _rutController;
  late final TextEditingController _fechaNacimientoController;
  late final TextEditingController _sistemaSaludController;
  late final TextEditingController _domicilioController;
  late final TextEditingController _telefonoController;

  bool _isLoading = false;
  DateTime? _fechaNacimiento;

  @override
  void initState() {
    super.initState();
    
    // Inicializar controladores con datos existentes si es edición
    final paciente = widget.paciente;
    
    _nombreController = TextEditingController(text: paciente?.nombre ?? '');
    _apellidoController = TextEditingController(text: paciente?.apellido ?? '');
    _rutController = TextEditingController(text: paciente?.rut ?? '');
    _fechaNacimientoController = TextEditingController(
      text: paciente?.fechanacimiento ?? '',
    );
    _sistemaSaludController = TextEditingController(text: paciente?.sistemadesalud ?? '');
    _domicilioController = TextEditingController(text: paciente?.domicilio ?? '');
    _telefonoController = TextEditingController(text: paciente?.telefono ?? '');

    if (paciente?.fechanacimiento != null) {
      try {
        _fechaNacimiento = DateTime.parse(paciente!.fechanacimiento!);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _rutController.dispose();
    _fechaNacimientoController.dispose();
    _sistemaSaludController.dispose();
    _domicilioController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0EA5E9),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _fechaNacimiento = picked;
        _fechaNacimientoController.text =
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _guardarPaciente() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final pacienteData = {
      'nombre': _nombreController.text.trim(),
      'apellido': _apellidoController.text.trim(),
      'rut': _rutController.text.trim(),
      'fechaNacimiento': _fechaNacimientoController.text.trim(),
      'sistemaDeSalud': _sistemaSaludController.text.trim().isEmpty 
          ? null 
          : _sistemaSaludController.text.trim(),
      'domicilio': _domicilioController.text.trim().isEmpty 
          ? null 
          : _domicilioController.text.trim(),
      'telefono': _telefonoController.text.trim().isEmpty 
          ? null 
          : _telefonoController.text.trim(),
    };

    Map<String, dynamic> result;

    if (widget.paciente == null) {
      // Crear nuevo paciente
      result = await _apiService.crearPaciente(pacienteData);
    } else {
      // Actualizar paciente existente
      final Map<String, dynamic> updateData = {
        ...pacienteData,
        'idPersona': widget.paciente!.idpersona,
      };
      result = await _apiService.actualizarPaciente(updateData);
    }

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true); // Retorna true para indicar cambios
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.paciente != null;
    final title = isEditing ? 'Editar Paciente' : 'Nuevo Paciente';

    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FF),
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        elevation: 0,
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
              _buildHeader(isEditing),
              const SizedBox(height: 24),
              _buildSection(
                title: 'Datos personales',
                icon: Icons.person_outline,
                children: [
                  _buildTextField(
                    controller: _nombreController,
                    label: 'Nombre',
                    icon: Icons.badge_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El nombre es requerido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _apellidoController,
                    label: 'Apellido',
                    icon: Icons.badge_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El apellido es requerido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _rutController,
                    label: 'RUT',
                    icon: Icons.fingerprint,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El RUT es requerido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: 'Datos de salud',
                icon: Icons.local_hospital_outlined,
                children: [
                  _buildTextField(
                    controller: _sistemaSaludController,
                    label: 'Sistema de salud',
                    icon: Icons.medical_services_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: 'Datos de contacto',
                icon: Icons.contact_page_outlined,
                children: [
                  _buildTextField(
                    controller: _domicilioController,
                    label: 'Domicilio',
                    icon: Icons.home_outlined,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _telefonoController,
                    label: 'Teléfono',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildActionButtons(isEditing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isEditing) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x330EA5E9),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isEditing ? Icons.edit : Icons.person_add,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Actualizar información' : 'Registrar paciente',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isEditing
                      ? 'Modifica los datos del paciente'
                      : 'Completa el formulario',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF0284C7), size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF0EA5E9)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0EA5E9), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
      ),
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _fechaNacimientoController,
      decoration: InputDecoration(
        labelText: 'Fecha de Nacimiento',
        prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF0EA5E9)),
        suffixIcon: IconButton(
          icon: const Icon(Icons.edit_calendar, color: Color(0xFF0EA5E9)),
          onPressed: _seleccionarFecha,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0EA5E9), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
      ),
      readOnly: true,
      onTap: _seleccionarFecha,
    );
  }

  Widget _buildActionButtons(bool isEditing) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Color(0xFF0EA5E9)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0EA5E9),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _guardarPaciente,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0EA5E9),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    isEditing ? 'Actualizar' : 'Crear Paciente',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
