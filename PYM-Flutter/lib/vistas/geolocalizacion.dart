import 'package:flutter/material.dart';
import '../servicios/geolocalizacion.dart';

class GeolocalizacionPage extends StatefulWidget {
  const GeolocalizacionPage({super.key});

  @override
  State<GeolocalizacionPage> createState() => _GeolocalizacionPageState();
}

class _GeolocalizacionPageState extends State<GeolocalizacionPage> {
  final GeolocalizacionService _geoService = GeolocalizacionService();
  bool _isLoading = false;
  Map<String, dynamic>? _ubicacionData;
  String? _error;

  @override
  void initState() {
    super.initState();
    _obtenerUbicacion();
  }

  Future<void> _obtenerUbicacion() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await _geoService.obtenerUbicacionCompleta();
      setState(() {
        _ubicacionData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al obtener la ubicación: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geolocalización PYM'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade400, Colors.blue.shade900],
          ),
        ),
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _obtenerUbicacion,
        backgroundColor: Colors.white,
        child: const Icon(Icons.refresh, color: Colors.blue),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 20),
            Text(
              'Obteniendo ubicación...',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 60),
              const SizedBox(height: 20),
              Text(
                _error!,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _obtenerUbicacion,
                child: const Text('Intentar de nuevo'),
              ),
            ],
          ),
        ),
      );
    }

    if (_ubicacionData == null) {
      return const Center(
        child: Text(
          'No se pudo obtener la ubicación',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mensaje principal
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 80,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '¡Hola, aquí está PYM!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '📍 ${_ubicacionData!['latitud'].toStringAsFixed(6)}, ${_ubicacionData!['longitud'].toStringAsFixed(6)}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Información de la dirección
          if (_ubicacionData!['direccion'] != null) ...[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.map, color: Colors.blue),
                        SizedBox(width: 10),
                        Text(
                          'Dirección',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    _buildInfoRow(
                      'Ubicación',
                      _ubicacionData!['direccion']['display_name'] ?? 'N/A',
                    ),
                    if (_ubicacionData!['direccion']['address'] != null) ...[
                      const SizedBox(height: 10),
                      _buildInfoRow(
                        'Ciudad',
                        _ubicacionData!['direccion']['address']['city'] ??
                            _ubicacionData!['direccion']['address']['town'] ??
                            _ubicacionData!['direccion']['address']['village'] ??
                            'N/A',
                      ),
                      const SizedBox(height: 10),
                      _buildInfoRow(
                        'País',
                        _ubicacionData!['direccion']['address']['country'] ??
                            'N/A',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Información del clima
          if (_ubicacionData!['clima'] != null &&
              _ubicacionData!['clima']['current_weather'] != null) ...[
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.wb_sunny, color: Colors.orange),
                        SizedBox(width: 10),
                        Text(
                          'Clima actual',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    _buildInfoRow(
                      'Temperatura',
                      '${_ubicacionData!['clima']['current_weather']['temperature']}°C',
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      'Velocidad del viento',
                      '${_ubicacionData!['clima']['current_weather']['windspeed']} km/h',
                    ),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Información técnica
          Card(
            elevation: 4,
            color: Colors.blue.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(
                        'APIs Utilizadas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text('✓ Geolocator - Obtener coordenadas GPS'),
                  const SizedBox(height: 5),
                  const Text('✓ Nominatim (OpenStreetMap) - Geocodificación'),
                  const SizedBox(height: 5),
                  const Text('✓ Open-Meteo - Información del clima'),
                  const SizedBox(height: 5),
                  const Text('✓ Dio - Cliente HTTP para Flutter'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
