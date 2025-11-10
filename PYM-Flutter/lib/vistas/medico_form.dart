import 'package:flutter/material.dart';
import '../servicios/auth.dart';
import '../servicios/api.dart';

class MedicoFormScreen extends StatefulWidget {
  final Map<String, dynamic> medico;

  const MedicoFormScreen({super.key, required this.medico});

  @override
  State<MedicoFormScreen> createState() => _MedicoFormScreenState();
}

class _MedicoFormScreenState extends State<MedicoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nombreController;
  late TextEditingController _apellidoController;
  late TextEditingController _rutController;
  late TextEditingController _emailController;
  late TextEditingController _telefonoController;
  late TextEditingController _fechaNacimientoController;
  
  DateTime? _fechaNacimiento;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    
    _nombreController = TextEditingController(
      text: widget.medico['nombre']?.toString() ?? '',
    );
    _apellidoController = TextEditingController(
      text: widget.medico['apellido']?.toString() ?? '',
    );
    _rutController = TextEditingController(
      text: widget.medico['rut']?.toString() ?? '',
    );
    _emailController = TextEditingController(
      text: widget.medico['email']?.toString() ?? '',
    );
    _telefonoController = TextEditingController(
      text: widget.medico['telefono']?.toString() ?? '',
    );
    
    // Parsear fecha de nacimiento
    final fechaStr = widget.medico['fechanacimiento']?.toString();
    if (fechaStr != null && fechaStr.isNotEmpty) {
      try {
        _fechaNacimiento = DateTime.parse(fechaStr);
        _fechaNacimientoController = TextEditingController(
          text: _formatearFecha(_fechaNacimiento!),
        );
      } catch (e) {
        _fechaNacimientoController = TextEditingController();
      }
    } else {
      _fechaNacimientoController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _rutController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _fechaNacimientoController.dispose();
    super.dispose();
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
  }

  Future<void> _seleccionarFecha() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaNacimiento ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
    );

    if (fecha != null) {
      setState(() {
        _fechaNacimiento = fecha;
        _fechaNacimientoController.text = _formatearFecha(fecha);
      });
    }
  }

  Future<void> _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _guardando = true;
    });

    try {
      final idMedico = widget.medico['idmedico'];
      
      if (idMedico == null) {
        throw Exception('ID de médico no encontrado');
      }

      // Preparar datos para enviar al servidor
      final datosActualizados = {
        'nombre': _nombreController.text.trim(),
        'apellido': _apellidoController.text.trim(),
        'rut': _rutController.text.trim(),
        'email': _emailController.text.trim().isEmpty 
            ? null 
            : _emailController.text.trim(),
        'telefono': _telefonoController.text.trim().isEmpty 
            ? null 
            : _telefonoController.text.trim(),
        'fechanacimiento': _fechaNacimiento?.toIso8601String(),
      };

      // Llamar al API para actualizar en el servidor
      final apiService = ApiService();
      final resultado = await apiService.actualizarMedico(idMedico, datosActualizados);

      if (!mounted) return;

      if (resultado['success'] == true) {
        // Actualizar sesión local con los nuevos datos
        final medicoActualizado = {
          ...widget.medico,
          ...datosActualizados,
        };

        final auth = AuthService();
        await auth.saveSession(medicoActualizado);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultado['message'] ?? 'Perfil actualizado correctamente'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultado['message'] ?? 'Error al actualizar perfil'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _guardando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF4F9FF),
      appBar: AppBar(
        title: const Text('Editar perfil'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0284C7), Color(0xFF014F86)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Actualiza tu información personal',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
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
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        // Datos personales
                        const Text(
                          'Datos personales',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        TextFormField(
                          controller: _nombreController,
                          decoration: InputDecoration(
                            labelText: 'Nombre *',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El nombre es requerido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        TextFormField(
                          controller: _apellidoController,
                          decoration: InputDecoration(
                            labelText: 'Apellido *',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El apellido es requerido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        TextFormField(
                          controller: _rutController,
                          decoration: InputDecoration(
                            labelText: 'RUT *',
                            prefixIcon: const Icon(Icons.badge_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            helperText: 'Ej: 12345678-9',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El RUT es requerido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        TextFormField(
                          controller: _fechaNacimientoController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Fecha de nacimiento',
                            prefixIcon: const Icon(Icons.cake_outlined),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: _seleccionarFecha,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onTap: _seleccionarFecha,
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Datos de contacto
                        const Text(
                          'Datos de contacto',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.mail_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            helperText: 'Opcional',
                          ),
                          validator: (value) {
                            if (value != null && value.trim().isNotEmpty) {
                              final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                              if (!emailRegex.hasMatch(value.trim())) {
                                return 'Email inválido';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        TextFormField(
                          controller: _telefonoController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Teléfono',
                            prefixIcon: const Icon(Icons.phone_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            helperText: 'Opcional',
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Botones
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _guardando
                                    ? null
                                    : () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  side: const BorderSide(
                                    color: Color(0xFF0284C7),
                                  ),
                                ),
                                child: const Text(
                                  'Cancelar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _guardando ? null : _guardarCambios,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0284C7),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: _guardando
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : const Text(
                                        'Guardar',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '* Campos obligatorios',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
