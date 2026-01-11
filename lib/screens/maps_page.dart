import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/farming_location.dart';
import '../services/location_service.dart';

class MapsPage extends StatefulWidget {
  const MapsPage({super.key});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  LatLng? userLocation;
  double radiusKm = 3;

  final Distance _distance = const Distance();

  final List<FarmingLocation> locations = [
    FarmingLocation(
      id: '1',
      name: 'Urban Farming Jakarta',
      lat: -6.200000,
      lng: 106.816666,
    ),
    FarmingLocation(
      id: '2',
      name: 'Hydroponic Community',
      lat: -6.210000,
      lng: 106.845000,
    ),
    FarmingLocation(
      id: '3',
      name: 'Growana Green House',
      lat: -6.185000,
      lng: 106.800000,
    ),
    FarmingLocation(
      id: '4',
      name: 'Balcony Farming Hub',
      lat: -6.230000,
      lng: 106.820000,
    ),
    FarmingLocation(
      id: '5',
      name: 'Mini Farm Edu Center',
      lat: -6.195000,
      lng: 106.790000,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    final position = await LocationService.getCurrentLocation();
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  /// FILTER LOKASI BERDASARKAN RADIUS
  List<FarmingLocation> _filteredLocations() {
    if (userLocation == null) return [];

    return locations.where((loc) {
      final km = _distance.as(
        LengthUnit.Kilometer,
        userLocation!,
        LatLng(loc.lat, loc.lng),
      );
      return km <= radiusKm;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (userLocation == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final visibleLocations = _filteredLocations();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi Urban Farming'),
        backgroundColor: const Color(0xFF1D7140),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: userLocation!,
                initialZoom: 14,
              ),
              children: [
                /// MAP TILE
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.growana',
                ),

                /// RADIUS CIRCLE
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: userLocation!,
                      radius: radiusKm * 1000,
                      useRadiusInMeter: true,
                      color: Colors.green.withOpacity(0.2),
                      borderStrokeWidth: 2,
                      borderColor: Colors.green,
                    ),
                  ],
                ),

                /// MARKERS
                MarkerLayer(
                  markers: [
                    /// USER MARKER
                    Marker(
                      point: userLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 32,
                      ),
                    ),

                    /// FARMING LOCATION MARKERS (DINAMIS BERDASARKAN RADIUS)
                    ...visibleLocations.map(
                      (loc) => Marker(
                        point: LatLng(loc.lat, loc.lng),
                        width: 40,
                        height: 40,
                        child: Tooltip(
                          message: loc.name,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// RADIUS SLIDER
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  'Lokasi berdasarkan estimasi browser',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(
                  'Radius: ${radiusKm.toInt()} km • ${visibleLocations.length} lokasi ditemukan',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Slider(
                  min: 1,
                  max: 10,
                  divisions: 9,
                  value: radiusKm,
                  label: '${radiusKm.toInt()} km',
                  onChanged: (value) {
                    setState(() {
                      radiusKm = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
