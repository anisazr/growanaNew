// lib/screens/maps_page.dart - FIXED
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/location_service.dart';
import '../services/exhibition_service.dart';
import '../models/exhibition_model.dart';

// Import Position dari geolocator
import 'package:geolocator/geolocator.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  late final MapController _mapController;
  LatLng? _currentLocation;
  Position? _currentPosition; // Position dari geolocator
  double _radiusKm = 10.0;
  bool _isLoading = true;
  bool _showUserLocation = true;
  bool _showExhibitions = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getUserLocation();
  }

  @override
  void dispose() {
    //LocationService().stopLocationUpdates();
    super.dispose();
  }

  Future<void> _getUserLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Panggil static method
      final position = await LocationService.getCurrentLocation();
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _currentPosition = position;
        _isLoading = false;
      });
      
      // Center map on user location
      if (_currentLocation != null) {
        _mapController.move(_currentLocation!, 13.0);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal mendapatkan lokasi: $e';
        _isLoading = false;
        // Default to Jakarta if location fails
        _currentLocation = const LatLng(-6.2088, 106.8456);
      });
    }
  }

  void _centerOnUserLocation() {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 13.0);
    }
  }

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    final center = _mapController.camera.center;
    _mapController.move(center, currentZoom + 1);
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    final center = _mapController.camera.center;
    _mapController.move(center, currentZoom - 1);
  }

  Future<void> _openMapsDirections(LatLng destination) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${destination.latitude},${destination.longitude}'
      '&travelmode=driving',
    );
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat membuka Google Maps')),
      );
    }
  }

  Widget _buildMap() {
    final exhibitionService = Provider.of<ExhibitionService>(context);
    final exhibitions = exhibitionService.allExhibitions;

    // Get nearby exhibitions
    final nearbyExhibitions = _currentLocation != null
        ? exhibitions.where((exhibition) {
            final distance = LocationService.calculateDistance(
              _currentLocation!.latitude,
              _currentLocation!.longitude,
              exhibition.latitude,
              exhibition.longitude,
            );
            return distance <= _radiusKm;
          }).toList()
        : [];

    return Stack(
      children: [
        // Map
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _currentLocation ?? const LatLng(-6.2088, 106.8456),
            initialZoom: 13.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
          ),
          children: [
            // Base map layer
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'com.growana.app',
            ),

            // User location circle
            if (_showUserLocation && _currentLocation != null)
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: _currentLocation!,
                    radius: _radiusKm * 1000,
                    useRadiusInMeter: true,
                    color: const Color(0xFF1D7140).withOpacity(0.2),
                    borderColor: const Color(0xFF1D7140),
                    borderStrokeWidth: 2,
                  ),
                ],
              ),

            // User location marker
            if (_showUserLocation && _currentLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentLocation!,
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () {
                        if (!mounted) return;
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Lokasi Anda'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Lat: ${_currentLocation!.latitude.toStringAsFixed(6)}'),
                                Text('Lng: ${_currentLocation!.longitude.toStringAsFixed(6)}'),
                                if (_currentPosition != null) ...[
                                  const SizedBox(height: 8),
                                  Text('Akurasi: ${_currentPosition!.accuracy.toStringAsFixed(2)}m'),
                                ],
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Tutup'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.person_pin_circle,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),

            // Exhibition markers
            if (_showExhibitions)
              MarkerLayer(
                markers: exhibitions.map((exhibition) {
                  return Marker(
                    point: LatLng(exhibition.latitude, exhibition.longitude),
                    width: 40,
                    height: 40,
                    child: GestureDetector(
                      onTap: () {
                        if (!mounted) return;
                        _showExhibitionInfo(exhibition);
                      },
                      child: Icon(
                        exhibition.isFeatured
                            ? Icons.star
                            : Icons.location_on,
                        color: exhibition.isFeatured ? Colors.orange : Colors.red,
                        size: 35,
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),

        // Map controls
        Positioned(
          right: 16,
          bottom: 16,
          child: Column(
            children: [
              FloatingActionButton.small(
                heroTag: 'zoom_in',
                onPressed: _zoomIn,
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: 'zoom_out',
                onPressed: _zoomOut,
                child: const Icon(Icons.remove),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.small(
                heroTag: 'center',
                onPressed: _centerOnUserLocation,
                child: const Icon(Icons.my_location),
              ),
            ],
          ),
        ),

        // Radius controls
        Positioned(
          left: 16,
          bottom: 16,
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Radius Pencarian',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${_radiusKm.toInt()} km',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D7140),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: Slider(
                      value: _radiusKm,
                      min: 1,
                      max: 50,
                      divisions: 49,
                      label: '${_radiusKm.toInt()} km',
                      onChanged: (value) {
                        setState(() {
                          _radiusKm = value;
                        });
                      },
                    ),
                  ),
                  Text(
                    '${nearbyExhibitions.length} pameran ditemukan',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Toggle controls
        Positioned(
          top: 16,
          right: 16,
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Lokasi Saya'),
                    value: _showUserLocation,
                    onChanged: (value) {
                      setState(() {
                        _showUserLocation = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                  SwitchListTile(
                    title: const Text('Pameran'),
                    value: _showExhibitions,
                    onChanged: (value) {
                      setState(() {
                        _showExhibitions = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showExhibitionInfo(Exhibition exhibition) {
    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      exhibition.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (exhibition.isFeatured)
                    const Icon(Icons.star, color: Colors.orange),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                exhibition.location,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(exhibition.formattedDate),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: exhibition.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: exhibition.statusColor),
                    ),
                    child: Text(
                      exhibition.statusText,
                      style: TextStyle(color: exhibition.statusColor),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(exhibition.formattedTicketPrice),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.directions),
                      label: const Text('Petunjuk Arah'),
                      onPressed: () {
                        Navigator.pop(context);
                        _openMapsDirections(
                          LatLng(exhibition.latitude, exhibition.longitude),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D7140),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Mendapatkan lokasi...'),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_off, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? 'Error mendapatkan lokasi',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
            onPressed: _getUserLocation,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Pameran'),
        backgroundColor: const Color(0xFF1D7140),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getUserLocation,
            tooltip: 'Refresh lokasi',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoading()
          : _errorMessage != null
              ? _buildError()
              : _buildMap(),
    );
  }
}