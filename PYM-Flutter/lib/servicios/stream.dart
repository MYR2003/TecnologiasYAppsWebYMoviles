import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = "http://10.0.2.2";

class StreamService {
  Stream<List<dynamic>> getDataStream({
    required int port,
    String endpoint = '',
    int intervalSeconds = 3,
  }) async* {
    while (true) {
      try {
        final uri = Uri.parse('$baseUrl:$port/$endpoint');
        final res = await http
            .get(uri)
            .timeout(const Duration(seconds: 8));

        if (res.statusCode == 200) {
          final data = jsonDecode(utf8.decode(res.bodyBytes));
          if (data is List) {
            yield data;
          } else {
            print('La respuesta no es una lista en $uri');
            yield [];
          }
        } else {
          print('Error HTTP ${res.statusCode} en $uri');
          yield [];
        }
      } catch (e) {
        print('Error en stream ($port): $e');
        yield [];
      }
      await Future.delayed(Duration(seconds: intervalSeconds));
    }
  }
}
