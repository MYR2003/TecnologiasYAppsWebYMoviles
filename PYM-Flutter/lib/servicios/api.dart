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

  Future<Map<String, dynamic>> _getPaginated(
    String endpoint, {
    int port = 3000,
    int limit = 20,
    int offset = 0,
    Map<String, dynamic> queryParams = const {},
  }) async {
    final normalizedEndpoint =
        endpoint.isNotEmpty && !endpoint.startsWith('/') ? '/$endpoint' : endpoint;

    final qp = {
      'limit': limit.toString(),
      'offset': offset.toString(),
      ...queryParams.map((k, v) => MapEntry(k, v?.toString() ?? '')),
    }..removeWhere((key, value) => value.isEmpty);

    final queryString = qp.entries.map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}').join('&');
    final Uri url = Uri.parse('$_baseHost:$port$normalizedEndpoint?$queryString');
    print('GET paginado -> $url');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 8));
      print('Codigo de respuesta: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        if (decoded is Map && decoded['data'] is List) {
          return {
            'data': decoded['data'] as List,
            'total': decoded['total'] ?? (decoded['data'] as List).length,
            'limit': decoded['limit'] ?? limit,
            'offset': decoded['offset'] ?? offset,
            'hasMore': decoded['hasMore'] ?? false,
          };
        }
        if (decoded is List) {
          final lista = decoded;
          return {
            'data': lista,
            'total': lista.length,
            'limit': limit,
            'offset': offset,
            'hasMore': lista.length >= limit,
          };
        }
      }

      print('Respuesta no esperada: ${response.body}');
      return {'data': <dynamic>[], 'total': 0, 'limit': limit, 'offset': offset, 'hasMore': false};
    } catch (e) {
      print('Error en getPaginated $endpoint -> $e');
      return {'data': <dynamic>[], 'total': 0, 'limit': limit, 'offset': offset, 'hasMore': false};
    }
  }

  Future<List<dynamic>> _getList(String endpoint, {int port = 3000}) async {
    final Uri url = Uri.parse('$_baseHost:$port/$endpoint');
    print('GET -> $url');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 8));

      print('Codigo de respuesta: ${response.statusCode}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(utf8.decode(response.bodyBytes));
        if (decoded is List) {
          print('${decoded.length} registros recibidos de $endpoint');
          return decoded;
        } else if (decoded is Map && decoded['data'] is List) {
          final lista = decoded['data'] as List;
          print('${lista.length} registros recibidos de $endpoint (data)');
          return lista;
        } else {
          print('La respuesta no es una lista');
          return [];
        }
      } else {
        print('Error ${response.statusCode}: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error al conectar con $endpoint -> $e');
      return [];
    }
  }

  // Pacientes
  Future<List<dynamic>> getPacientes() async {
    final resp = await getPacientesPaginated(limit: 100);
    return resp['data'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> getPacientesPaginated({
    int limit = 20,
    int offset = 0,
  }) async {
    return await _getPaginated('', port: 3016, limit: limit, offset: offset);
  }

  // Consultas
  Future<List<dynamic>> getConsultas() async {
    final resp = await getConsultasPaginated(limit: 100);
    return resp['data'] as List<dynamic>;
  }

  Future<Map<String, dynamic>> getConsultasPaginated({
    int limit = 20,
    int offset = 0,
    int? idMedico,
  }) async {
    final qp = <String, dynamic>{};
    if (idMedico != null) {
      qp['idmedico'] = idMedico;
    }
    return await _getPaginated(
      '',
      port: 3002,
      limit: limit,
      offset: offset,
      queryParams: qp,
    );
  }

  // Medicos
  Future<List<dynamic>> getMedicos() async {
    return await _getList('', port: 3015);
  }

  // ======== CRUD Pacientes ========

  Future<Map<String, dynamic>> crearPaciente(
      Map<String, dynamic> pacienteData) async {
    final Uri url = Uri.parse('$_baseHost:3016/');
    print('POST -> $url');
    print('Datos: $pacienteData');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(pacienteData),
          )
          .timeout(const Duration(seconds: 8));

      print('Codigo de respuesta: ${response.statusCode}');

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
      print('Error al conectar con el servidor -> $e');
      return {'success': false, 'message': 'Error de conexion: $e'};
    }
  }

  Future<Map<String, dynamic>> actualizarPaciente(
      Map<String, dynamic> pacienteData) async {
    final Uri url = Uri.parse('$_baseHost:3016/');
    print('PUT -> $url');
    print('Datos: $pacienteData');

    try {
      final response = await http
          .put(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(pacienteData),
          )
          .timeout(const Duration(seconds: 8));

      print('Codigo de respuesta: ${response.statusCode}');

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
      print('Error al conectar con el servidor -> $e');
      return {'success': false, 'message': 'Error de conexion: $e'};
    }
  }

  Future<Map<String, dynamic>> eliminarPaciente(int idPersona) async {
    final Uri url = Uri.parse('$_baseHost:3016/');
    print('DELETE -> $url');
    print('ID: $idPersona');

    try {
      final response = await http
          .delete(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'id': idPersona}),
          )
          .timeout(const Duration(seconds: 8));

      print('Codigo de respuesta: ${response.statusCode}');

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
      print('Error al conectar con el servidor -> $e');
      return {'success': false, 'message': 'Error de conexion: $e'};
    }
  }

  // ======== CRUD Medicos ========

  Future<Map<String, dynamic>> actualizarMedico(
      int idMedico, Map<String, dynamic> medicoData) async {
    final Uri url = Uri.parse('$_baseHost:3015/$idMedico');
    print('PUT -> $url');
    print('Datos: $medicoData');

    try {
      final response = await http
          .put(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(medicoData),
          )
          .timeout(const Duration(seconds: 8));

      print('Codigo de respuesta: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Medico actualizado exitosamente');
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
          'message': 'Error al actualizar medico: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Error al conectar con el servidor -> $e');
      return {'success': false, 'message': 'Error de conexion: $e'};
    }
  }

  // ======== CRUD Consultas ========

  Future<Map<String, dynamic>> crearConsulta(
      Map<String, dynamic> consultaData) async {
    final Uri url = Uri.parse('$_baseHost:3002/');
    print('POST -> $url');
    print('Datos: $consultaData');

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(consultaData),
          )
          .timeout(const Duration(seconds: 8));

      print('Codigo de respuesta: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Consulta creada correctamente'
        };
      }

      return {
        'success': false,
        'message': 'Error al crear consulta: ${response.statusCode}'
      };
    } catch (e) {
      print('Error al crear consulta -> $e');
      return {'success': false, 'message': 'Error de conexion: $e'};
    }
  }

  Future<Map<String, dynamic>> actualizarConsulta(
      int idConsulta, Map<String, dynamic> consultaData) async {
    final Uri url = Uri.parse('$_baseHost:3002/$idConsulta');
    print('PUT -> $url');
    print('Datos: $consultaData');

    try {
      final response = await http
          .put(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(consultaData),
          )
          .timeout(const Duration(seconds: 8));

      print('Codigo de respuesta: ${response.statusCode}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Consulta actualizada correctamente'
        };
      }

      return {
        'success': false,
        'message': 'Error al actualizar consulta: ${response.statusCode}'
      };
    } catch (e) {
      print('Error al actualizar consulta -> $e');
      return {'success': false, 'message': 'Error de conexion: $e'};
    }
  }

  Future<Map<String, dynamic>> eliminarConsulta(int idConsulta) async {
    final Uri url = Uri.parse('$_baseHost:3002/$idConsulta');
    print('DELETE -> $url');

    try {
      final response = await http
          .delete(
            url,
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 8));

      print('Codigo de respuesta: ${response.statusCode}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Consulta eliminada correctamente'
        };
      }

      return {
        'success': false,
        'message': 'Error al eliminar consulta: ${response.statusCode}'
      };
    } catch (e) {
      print('Error al eliminar consulta -> $e');
      return {'success': false, 'message': 'Error de conexion: $e'};
    }
  }
}
