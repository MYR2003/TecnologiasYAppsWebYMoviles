import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

class GeolocalizacionService {
  final Dio _dio = Dio();

  // Obtener la ubicación actual del dispositivo
  Future<Position?> obtenerUbicacionActual() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si los servicios de ubicación están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Los servicios de ubicación están deshabilitados.');
      return null;
    }

    // Verificar permisos
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Los permisos de ubicación fueron denegados');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Los permisos de ubicación están permanentemente denegados.');
      return null;
    }

    // Obtener la ubicación actual
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Obtener información de la dirección usando la API de Nominatim (OpenStreetMap)
  Future<Map<String, dynamic>?> obtenerDireccion(
      double latitud, double longitud) async {
    try {
      final url =
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitud&lon=$longitud&zoom=18&addressdetails=1';

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'User-Agent': 'PYM-Flutter-App/1.0',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      print('Error al obtener la dirección: $e');
      return null;
    }
  }

  // Obtener información del clima usando la API de Open-Meteo (otra API pública)
  Future<Map<String, dynamic>?> obtenerClima(
      double latitud, double longitud) async {
    try {
      final url =
          'https://api.open-meteo.com/v1/forecast?latitude=$latitud&longitude=$longitud&current_weather=true';

      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      print('Error al obtener el clima: $e');
      return null;
    }
  }

  // Método combinado que obtiene ubicación y dirección
  Future<Map<String, dynamic>?> obtenerUbicacionCompleta() async {
    final position = await obtenerUbicacionActual();
    if (position == null) return null;

    final direccion = await obtenerDireccion(
      position.latitude,
      position.longitude,
    );

    final clima = await obtenerClima(
      position.latitude,
      position.longitude,
    );

    return {
      'latitud': position.latitude,
      'longitud': position.longitude,
      'direccion': direccion,
      'clima': clima,
    };
  }
}