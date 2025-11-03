import 'package:flutter/material.dart';
import '../servicios/auth.dart';
import 'login.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  Map<String, dynamic>? medico;
  bool cargando = true;
  final TextEditingController _correoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarPerfil();
  }

  @override
  void dispose() {
    _correoController.dispose();
    super.dispose();
  }

  Future<void> _cargarPerfil() async {
    final auth = AuthService();
    final session = await auth.getSession();

    if (!mounted) return;
    setState(() {
      medico = session;
      cargando = false;
    });
    _correoController.text = (session?['correo'] ?? 'Sin correo registrado')
        .toString();
  }

  Future<void> _cerrarSesion() async {
    final auth = AuthService();
    await auth.clearSession();

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginView()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (medico == null) {
      return const Scaffold(body: Center(child: Text('No hay sesión activa')));
    }

    final nombre = (medico?['nombre'] ?? 'Profesional PYM').toString();
    final especialidad = (medico?['especialidad'] ?? 'Sin especialidad')
        .toString();
    final rut = (medico?['rut'] ?? 'No disponible').toString();
    final correo = (medico?['correo'] ?? 'Sin correo registrado').toString();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF4F9FF),
      appBar: AppBar(
        title: const Text('Mi perfil PYM'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _cerrarSesion),
        ],
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileHero(nombre: nombre, especialidad: especialidad),
                const SizedBox(height: 30),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x33027BB7),
                          offset: Offset(0, -2),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Datos profesionales',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 18),
                        _ProfileRow(
                          icon: Icons.badge_outlined,
                          label: 'RUT',
                          value: rut,
                        ),
                        const SizedBox(height: 14),
                        _ProfileRow(
                          icon: Icons.mail_outline,
                          label: 'Correo contacto',
                          value: correo,
                          trailing: TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: _editarCorreo,
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: Color(0xFF0284C7),
                            ),
                            label: const Text(
                              'Editar',
                              style: TextStyle(
                                color: Color(0xFF0284C7),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _ProfileRow(
                          icon: Icons.medical_services_outlined,
                          label: 'Especialidad',
                          value: especialidad,
                        ),
                        const Spacer(),
                        Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0EA5E9),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              onPressed: _cerrarSesion,
                              icon: const Icon(Icons.logout),
                              label: const Text(
                                'Cerrar sesión',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Future<void> _editarCorreo() async {
    _correoController.text = (medico?['correo'] ?? 'Sin correo registrado')
        .toString();

    final nuevoCorreo = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: _EditarCorreoSheet(controller: _correoController),
        );
      },
    );

    if (nuevoCorreo == null) return;

    final trimmed = nuevoCorreo.trim();
    if (trimmed.isEmpty || trimmed == medico?['correo']) return;

    final emailRegExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegExp.hasMatch(trimmed)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un correo válido.')),
      );
      return;
    }

    final actualizado = {...?medico, 'correo': trimmed};

    setState(() {
      medico = actualizado;
    });

    final auth = AuthService();
    await auth.saveSession(actualizado);

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Correo actualizado.')));
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.nombre, required this.especialidad});

  final String nombre;
  final String especialidad;

  @override
  Widget build(BuildContext context) {
    final iniciales = nombre.trim().isNotEmpty
        ? nombre
              .trim()
              .split(RegExp(r'\s+'))
              .take(2)
              .map((e) => e[0])
              .join()
              .toUpperCase()
        : 'PY';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white.withOpacity(0.16),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          Container(
            height: 80,
            width: 80,
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
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  especialidad,
                  style: const TextStyle(
                    color: Colors.white70,
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

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF0284C7), size: 24),
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
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(color: Color(0xFF0F172A), fontSize: 16),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 12), trailing!],
      ],
    );
  }
}

class _EditarCorreoSheet extends StatelessWidget {
  const _EditarCorreoSheet({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Actualizar correo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.mail_outline),
              labelText: 'Correo electrónico',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0284C7),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: const Text(
                'Guardar cambios',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
