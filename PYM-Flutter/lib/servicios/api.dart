import 'dart:convert';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:http/http.dart' as http;

const String _androidEmulatorHost = 'http://10.0.2.2';
const String _desktopHost = 'http://127.0.0.1';
const String _webHost = 'http://localhost';

String _resolveBaseHost() {
  if (kIsWeb) {
    return _webHost;
  }
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return _androidEmulatorHost;
    default:
      return _desktopHost;
  }
}

class ApiService {
  ApiService({String? baseHost}) : _baseHost = baseHost ?? _resolveBaseHost();

  final String _baseHost;

  Future<List<dynamic>> _getList(String endpoint, {int port = 3000}) async {
    final Uri url = Uri.parse('$_baseHost:$port/$endpoint');
    print('GET → $url');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 8));

      print('Código de respuesta: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        if (decoded is List) {
          print('${decoded.length} registros recibidos de $endpoint');
          return decoded;
        } else {
          print('La respuesta no es una lista');
          return [];
        }
      } else {
        print('Error ${response.statusCode}: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error al conectar con $endpoint → $e');
      return [];
    }
  }

  // Pacientes
  Future<List<dynamic>> getPacientes() async {
    return await _getList('', port: 3016);
  }

  // Consultas
  Future<List<dynamic>> getConsultas() async {
    return await _getList('', port: 3002);
  }

  // Médicos
  Future<List<dynamic>> getMedicos() async {
    return await _getList('', port: 3015);
  }

  // ======== CRUD Pacientes ========

  /// Crear un nuevo paciente
  Future<Map<String, dynamic>> crearPaciente(
      Map<String, dynamic> pacienteData) async {
    final Uri url = Uri.parse('$_baseHost:3016/');
    print('POST → $url');
    print('Datos: $pacienteData');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(pacienteData),
          )
          .timeout(const Duration(seconds: 8));

      print('Código de respuesta: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Paciente creado exitosamente');
        return {'success': true, 'message': 'Paciente creado exitosamente'};
      } else {
        print('Error ${response.statusCode}: ${response.body}');
        return {
          'success': false,
          'message': 'Error al crear paciente: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Error al conectar con el servidor → $e');
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  /// Actualizar un paciente existente
  Future<Map<String, dynamic>> actualizarPaciente(
      Map<String, dynamic> pacienteData) async {
    final Uri url = Uri.parse('$_baseHost:3016/');
    print('PUT → $url');
    print('Datos: $pacienteData');

    try {
      final response = await http
          .put(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(pacienteData),
          )
          .timeout(const Duration(seconds: 8));

      print('Código de respuesta: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Paciente actualizado exitosamente');
        return {
          'success': true,
          'message': 'Paciente actualizado exitosamente'
        };
      } else {
        print('Error ${response.statusCode}: ${response.body}');
        return {
          'success': false,
          'message': 'Error al actualizar paciente: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Error al conectar con el servidor → $e');
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  /// Eliminar un paciente
  Future<Map<String, dynamic>> eliminarPaciente(int idPersona) async {
    final Uri url = Uri.parse('$_baseHost:3016/');
    print('DELETE → $url');
    print('ID: $idPersona');

    try {
      final response = await http
          .delete(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'id': idPersona}),
          )
          .timeout(const Duration(seconds: 8));

      print('Código de respuesta: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Paciente eliminado exitosamente');
        return {
          'success': true,
          'message': 'Paciente eliminado exitosamente'
        };
      } else {
        print('Error ${response.statusCode}: ${response.body}');
        return {
          'success': false,
          'message': 'Error al eliminar paciente: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Error al conectar con el servidor → $e');
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  // ======== CRUD Médicos ========

  /// Actualizar un médico existente
  Future<Map<String, dynamic>> actualizarMedico(
      int idMedico, Map<String, dynamic> medicoData) async {
    final Uri url = Uri.parse('$_baseHost:3015/$idMedico');
    print('PUT → $url');
    print('Datos: $medicoData');

    try {
      final response = await http
          .put(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(medicoData),
          )
          .timeout(const Duration(seconds: 8));

      print('Código de respuesta: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Médico actualizado exitosamente');
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        return {
          'success': true,
          'message': 'Perfil actualizado correctamente',
          'data': decoded['data']
        };
      } else {
        print('Error ${response.statusCode}: ${response.body}');
        return {
          'success': false,
          'message': 'Error al actualizar médico: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Error al conectar con el servidor → $e');
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }
}
