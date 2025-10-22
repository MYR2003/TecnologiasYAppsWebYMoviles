import 'package:dio/dio.dart';

class GeolocalizacionService {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>?> obtenerUbicacion() async {
    const url = 'http://ip-api.com/json/';

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        print('Error HTTP: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error al obtener ubicación: $e');
      return null;
    }
  }
}
