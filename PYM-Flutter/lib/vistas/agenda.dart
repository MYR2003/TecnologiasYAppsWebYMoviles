import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../servicios/auth.dart';

const baseUrl = "http://10.0.2.2";

class AgendaView extends StatefulWidget {
  const AgendaView({super.key});

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  List<dynamic> consultas = [];
  List<dynamic> pacientes = [];
  bool cargando = true;
  int? idMedicoActual;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      final auth = AuthService();
      final medico = await auth.getSession();

      if (medico == null) {
        setState(() => cargando = false);
        return;
      }

      idMedicoActual = medico['idmedico'];

      // Obtener todas las consultas 
      final resConsultas = await http.get(Uri.parse('$baseUrl:3002/'));
      final resPacientes = await http.get(Uri.parse('$baseUrl:3016/'));

      if (resConsultas.statusCode == 200 && resPacientes.statusCode == 200) {
        final dataConsultas =
            jsonDecode(utf8.decode(resConsultas.bodyBytes)) as List<dynamic>;
        final dataPacientes =
            jsonDecode(utf8.decode(resPacientes.bodyBytes)) as List<dynamic>;

        // Guardamos la lista completa de pacientes
        pacientes = dataPacientes;

        // Filtramos las consultas del médico logueado
        final filtradas = dataConsultas
            .where((c) => c['idmedico'] == idMedicoActual)
            .toList();

        setState(() {
          consultas = filtradas;
          cargando = false;
        });
      } else {
        print("Error al cargar datos: ${resConsultas.statusCode} / ${resPacientes.statusCode}");
        setState(() => cargando = false);
      }
    } catch (e) {
      print("Error al cargar agenda: $e");
      setState(() => cargando = false);
    }
  }

  String _nombrePaciente(int idPersona) {
    final paciente = pacientes.firstWhere(
      (p) => p['idpersona'] == idPersona,
      orElse: () => null,
    );
    if (paciente == null) return 'Paciente desconocido';
    final nombre = paciente['nombre'] ?? '';
    final apellido = paciente['apellido'] ?? '';
    return '$nombre $apellido'.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Agenda Médica'),
        backgroundColor: const Color(0xFF03A9F4),
        elevation: 0,
      ),
      body: cargando
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF03A9F4)))
          : consultas.isEmpty
              ? const Center(
                  child: Text(
                    "No hay consultas registradas para este médico.",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: consultas.length,
                  itemBuilder: (context, index) {
                    final c = consultas[index];
                    final nombrePaciente = _nombrePaciente(c['idpersona']);

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: const Icon(Icons.event_note,
                            color: Color(0xFF03A9F4)),
                        title: Text(
                          'Consulta #${c['idconsulta']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Paciente: $nombrePaciente'),
                      ),
                    );
                  },
                ),
    );
  }
}
