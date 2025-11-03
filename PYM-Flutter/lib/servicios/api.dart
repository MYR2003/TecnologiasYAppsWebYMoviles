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
}
