import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "http://10.0.2.2";

class ApiService {
  Future<List<dynamic>> getPacientes() async {
    final url = Uri.parse('$baseUrl:3016/');
    print("Llamando a $url");

    try {
      final res = await http.get(url).timeout(const Duration(seconds: 5));
      print("Código de respuesta pacientes: ${res.statusCode}");

      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        print("${data.length} pacientes recibidos");
        return data;
      } else {
        print("Error pacientes: ${res.body}");
        return [];
      }
    } catch (e) {
      print("Error al cargar pacientes: $e");
      return [];
    }
  }

  Future<List<dynamic>> getConsultas() async {
    final url = Uri.parse('$baseUrl:3002/');
    print("Llamando a $url");

    try {
      final res = await http.get(url).timeout(const Duration(seconds: 5));
      print("Código de respuesta consultas: ${res.statusCode}");

      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        print("${data.length} consultas recibidas");
        return data;
      } else {
        print("Error consultas: ${res.body}");
        return [];
      }
    } catch (e) {
      print("Error al cargar consultas: $e");
      return [];
    }
  }

  Future<List<dynamic>> getMedicos() async {
    final url = Uri.parse('$baseUrl:3015/');
    print("Llamando a $url");

    try {
      final res = await http.get(url).timeout(const Duration(seconds: 5));
      print("Código de respuesta médicos: ${res.statusCode}");

      if (res.statusCode == 200) {
        final data = jsonDecode(utf8.decode(res.bodyBytes));
        print("${data.length} médicos recibidos");
        return data;
      } else {
        print("Error médicos: ${res.body}");
        return [];
      }
    } catch (e) {
      print("Error al cargar médicos: $e");
      return [];
    }
  }
}
