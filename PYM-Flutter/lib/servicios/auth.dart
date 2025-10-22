import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "http://10.0.2.2";

class AuthService {
  // Guarda los datos del médico
  Future<void> saveSession(Map<String, dynamic> medico) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('medico', jsonEncode(medico));
  }

  // Recupera el médico guardado
  Future<Map<String, dynamic>?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('medico');
    if (data == null) return null;
    return jsonDecode(data);
  }

  // Cierra la sesión
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('medico');
  }

  // Valida usuario (apellido + rut)
  Future<Map<String, dynamic>?> login(String apellido, String rut) async {
    final res = await http.get(Uri.parse('$baseUrl:3015/'));
    if (res.statusCode == 200) {
      final medicos = jsonDecode(utf8.decode(res.bodyBytes)) as List;
      try {
        final medico = medicos.firstWhere((m) =>
            (m['apellido']?.toString().toLowerCase() == apellido.toLowerCase()) &&
            (m['rut']?.toString().toLowerCase() == rut.toLowerCase()));
        await saveSession(medico);
        return medico;
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }
}
