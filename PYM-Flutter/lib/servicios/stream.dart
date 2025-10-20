import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "http://10.0.2.2";

class StreamService {
  // Consultas en tiempo real
  Stream<List<dynamic>> streamConsultas({int segundos = 3}) async* {
    while (true) {
      try {
        final res = await http.get(Uri.parse('$baseUrl:3002/'));
        if (res.statusCode == 200) {
          yield jsonDecode(utf8.decode(res.bodyBytes));
        } else {
          yield [];
        }
      } catch (e) {
        print("Error en stream de consultas: $e");
        yield [];
      }
      await Future.delayed(Duration(seconds: segundos));
    }
  }

  // Pacientes en tiempo real
  Stream<List<dynamic>> streamPacientes({int segundos = 3}) async* {
    while (true) {
      try {
        final res = await http.get(Uri.parse('$baseUrl:3016/'));
        if (res.statusCode == 200) {
          yield jsonDecode(utf8.decode(res.bodyBytes));
        } else {
          yield [];
        }
      } catch (e) {
        print("Error en stream de pacientes: $e");
        yield [];
      }
      await Future.delayed(Duration(seconds: segundos));
    }
  }

  // Médicos en tiempo real 
  Stream<List<dynamic>> streamMedicos({int segundos = 3}) async* {
    while (true) {
      try {
        final res = await http.get(Uri.parse('$baseUrl:3015/'));
        if (res.statusCode == 200) {
          yield jsonDecode(utf8.decode(res.bodyBytes));
        } else {
          yield [];
        }
      } catch (e) {
        print("Error en stream de médicos: $e");
        yield [];
      }
      await Future.delayed(Duration(seconds: segundos));
    }
  }
}
