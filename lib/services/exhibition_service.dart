// lib/services/exhibition_service.dart
import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/exhibition_model.dart';

class ExhibitionService extends ChangeNotifier {
  static final ExhibitionService _instance = ExhibitionService._internal();
  factory ExhibitionService() => _instance;
  ExhibitionService._internal() {
    _loadExhibitions();
  }

  final ValueNotifier<List<Exhibition>> _exhibitions = ValueNotifier([]);
  ValueNotifier<List<Exhibition>> get exhibitions => _exhibitions;

  final ValueNotifier<bool> _isLoading = ValueNotifier(false);
  ValueNotifier<bool> get isLoading => _isLoading;

  final ValueNotifier<String?> _error = ValueNotifier(null);
  ValueNotifier<String?> get error => _error;

  // API Configuration
  static const String _baseUrl = 'https://api.growana.example.com';
  static const String _apiPath = '/api/exhibitions';

  // Development mode
  static const bool _useMockData = true;

  // Getters
  List<Exhibition> get allExhibitions => _exhibitions.value;

  List<Exhibition> get featuredExhibitions =>
      _exhibitions.value.where((ex) => ex.isFeatured).toList();

  List<Exhibition> get ongoingExhibitions =>
      _exhibitions.value.where((ex) => ex.isOngoing).toList();

  List<Exhibition> get upcomingExhibitions =>
      _exhibitions.value.where((ex) => ex.isUpcoming).toList();

  List<Exhibition> getExhibitionsByLocation(String location) =>
      _exhibitions.value
          .where(
            (ex) => ex.location.toLowerCase().contains(location.toLowerCase()),
          )
          .toList();

  List<Exhibition> searchExhibitions(String query) {
    if (query.isEmpty) return _exhibitions.value;

    return _exhibitions.value.where((exhibition) {
      return exhibition.title.toLowerCase().contains(query.toLowerCase()) ||
          exhibition.description.toLowerCase().contains(query.toLowerCase()) ||
          exhibition.location.toLowerCase().contains(query.toLowerCase()) ||
          exhibition.tags.any(
            (tag) => tag.toLowerCase().contains(query.toLowerCase()),
          );
    }).toList();
  }

  Future<void> fetchExhibitions() async {
    if (_useMockData) {
      await _loadMockData();
      return;
    }

    _isLoading.value = true;
    _error.value = null;

    try {
      final response = await http
          .get(
            Uri.parse('$_baseUrl$_apiPath'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _exhibitions.value =
            data.map((item) => Exhibition.fromJson(item)).toList();
        notifyListeners();
      } else {
        _error.value = 'Failed to load exhibitions';
        await _loadMockData();
      }
    } catch (e) {
      _error.value = 'Error: $e';
      await _loadMockData();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> _loadExhibitions() async {
    await _loadMockData();
  }

  // ==========================
  // MOCK DATA (RELEVANT IMAGES)
  // ==========================
  Future<void> _loadMockData() async {
    await Future.delayed(const Duration(milliseconds: 500));

    _exhibitions.value = [
      Exhibition(
        id: '1',
        title: 'Pameran Hidroponik Modern',
        description:
            'Pameran teknologi hidroponik terkini untuk urban farming.',
        location: 'Jakarta Convention Center',
        imageUrl:
            'https://images.unsplash.com/photo-1581092334651-ddf26d9a09d0?w=1200&auto=format&fit=crop',
        startDate: DateTime(2024, 4, 12),
        endDate: DateTime(2024, 4, 15),
        latitude: -6.2274,
        longitude: 106.8078,
        organizer: 'Asosiasi Hidroponik Indonesia',
        tags: ['hidroponik', 'teknologi', 'urban farming'],
        isFeatured: true,
        ticketPrice: 50000,
      ),
      Exhibition(
        id: '2',
        title: 'Green Agriculture Expo 2024',
        description:
            'Event terbesar untuk pertanian organik dan berkelanjutan.',
        location: 'Bandung Creative Hub',
        imageUrl:
            'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?w=1200&auto=format&fit=crop',
        startDate: DateTime(2024, 4, 20),
        endDate: DateTime(2024, 4, 22),
        latitude: -6.9175,
        longitude: 107.6191,
        organizer: 'Green Agriculture Foundation',
        tags: ['organik', 'pertanian', 'expo'],
        isFeatured: true,
        ticketPrice: 75000,
      ),
      Exhibition(
        id: '3',
        title: 'Growana Future Farm',
        description:
            'Eksibisi pertanian masa depan berbasis smart farming dan IoT.',
        location: 'Surabaya Expo Center',
        imageUrl:
            'https://images.unsplash.com/photo-1627920769842-6887c6df05ca?w=1200&auto=format&fit=crop',
        startDate: DateTime(2024, 5, 1),
        endDate: DateTime(2024, 5, 3),
        latitude: -7.2575,
        longitude: 112.7521,
        organizer: 'Growana Community',
        tags: ['smart farming', 'iot', 'future'],
        isFeatured: false,
        ticketPrice: 0,
      ),
      Exhibition(
        id: '4',
        title: 'Urban Farming Festival',
        description:
            'Festival tahunan komunitas urban farming dan agrikultur kota.',
        location: 'Taman Menteng, Jakarta',
        imageUrl:
            'https://images.unsplash.com/photo-1591857177580-dc82b9ac4e1e?w=1200&auto=format&fit=crop',
        startDate: DateTime(2024, 4, 5),
        endDate: DateTime(2024, 4, 7),
        latitude: -6.1950,
        longitude: 106.8320,
        organizer: 'Jakarta Urban Farming',
        tags: ['urban', 'festival', 'komunitas'],
        isFeatured: true,
        ticketPrice: 0,
      ),
      Exhibition(
        id: '5',
        title: 'Vertical Garden Workshop',
        description: 'Workshop membuat vertical garden di lahan terbatas.',
        location: 'Mal Kota Kasablanka',
        imageUrl:
            'https://images.unsplash.com/photo-1524594152303-9fd13543fe6e?w=1200&auto=format&fit=crop',
        startDate: DateTime(2024, 4, 18),
        endDate: DateTime(2024, 4, 18),
        latitude: -6.2245,
        longitude: 106.8412,
        organizer: 'Vertical Garden Indonesia',
        tags: ['vertical garden', 'workshop', 'tanaman'],
        isFeatured: false,
        ticketPrice: 150000,
      ),
      Exhibition(
        id: '6',
        title: 'Aquaponics Technology Showcase',
        description:
            'Showcase sistem aquaponics sebagai solusi pertanian berkelanjutan.',
        location: 'Bogor Botanical Garden',
        imageUrl:
            'https://images.unsplash.com/photo-1550547660-d9450f859349?w=1200&auto=format&fit=crop',
        startDate: DateTime(2024, 4, 25),
        endDate: DateTime(2024, 4, 28),
        latitude: -6.5971,
        longitude: 106.7990,
        organizer: 'Aquaponics Research Center',
        tags: ['aquaponics', 'teknologi', 'sustainable'],
        isFeatured: false,
        ticketPrice: 30000,
      ),
    ];

    notifyListeners();
  }

  Future<void> refresh() async {
    await fetchExhibitions();
  }
}
