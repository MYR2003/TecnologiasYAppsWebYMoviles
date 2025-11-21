import 'dart:async';
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

class StreamService {
  StreamService({String? baseHost}) : _baseHost = baseHost ?? _resolveBaseHost();

  final String _baseHost;

  Stream<List<dynamic>> getDataStream({
    required int port,
    String endpoint = '',
    int intervalSeconds = 3,
  }) async* {
    while (true) {
      try {
        final normalizedEndpoint = endpoint.isEmpty
            ? ''
            : '/${endpoint.replaceFirst(RegExp('^/+'), '')}';
        final uri = Uri.parse('$_baseHost:$port$normalizedEndpoint');
        final res = await http
            .get(uri)
            .timeout(const Duration(seconds: 8));

        if (res.statusCode == 200) {
          final data = jsonDecode(utf8.decode(res.bodyBytes));
          if (data is List) {
            yield data;
          } else if (data is Map && data['data'] is List) {
            yield (data['data'] as List);
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
