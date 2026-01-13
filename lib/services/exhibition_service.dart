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
  static const String _baseUrl = 'https://api.growana.example.com'; // Ganti dengan API asli
  static const String _apiPath = '/api/exhibitions';
  
  // Untuk development, kita pakai mock data dulu
  static const bool _useMockData = true;

  // Get all exhibitions
  List<Exhibition> get allExhibitions => _exhibitions.value;

  // Get featured exhibitions
  List<Exhibition> get featuredExhibitions =>
      _exhibitions.value.where((ex) => ex.isFeatured).toList();

  // Get ongoing exhibitions
  List<Exhibition> get ongoingExhibitions =>
      _exhibitions.value.where((ex) => ex.isOngoing).toList();

  // Get upcoming exhibitions
  List<Exhibition> get upcomingExhibitions =>
      _exhibitions.value.where((ex) => ex.isUpcoming).toList();

  // Filter by location
  List<Exhibition> getExhibitionsByLocation(String location) =>
      _exhibitions.value
          .where((ex) => ex.location.toLowerCase().contains(location.toLowerCase()))
          .toList();

  // Search exhibitions
  List<Exhibition> searchExhibitions(String query) {
    if (query.isEmpty) return _exhibitions.value;
    
    return _exhibitions.value.where((exhibition) {
      return exhibition.title.toLowerCase().contains(query.toLowerCase()) ||
          exhibition.description.toLowerCase().contains(query.toLowerCase()) ||
          exhibition.location.toLowerCase().contains(query.toLowerCase()) ||
          exhibition.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }

  // Fetch exhibitions from API
  Future<void> fetchExhibitions() async {
    if (_useMockData) {
      // Use mock data for development
      await _loadMockData();
      return;
    }

    _isLoading.value = true;
    _error.value = null;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl$_apiPath'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _exhibitions.value = data
            .map((item) => Exhibition.fromJson(item))
            .toList();
        await _saveExhibitions(); // Cache to SharedPreferences
        notifyListeners();
      } else {
        _error.value = 'Failed to load exhibitions: ${response.statusCode}';
        // Fallback to cached data
        await _loadExhibitions();
      }
    } catch (e) {
      _error.value = 'Error: $e';
      // Fallback to cached data
      await _loadExhibitions();
    } finally {
      _isLoading.value = false;
    }
  }

  // Load exhibitions from SharedPreferences (cache)
  Future<void> _loadExhibitions() async {
    try {
      // TODO: Implement SharedPreferences cache
      // For now, load mock data
      await _loadMockData();
    } catch (e) {
      print('Error loading cached exhibitions: $e');
      await _loadMockData();
    }
  }

  // Save exhibitions to SharedPreferences (cache)
  Future<void> _saveExhibitions() async {
    try {
      // TODO: Implement SharedPreferences cache
    } catch (e) {
      print('Error saving exhibitions: $e');
    }
  }

  // Mock data untuk development
  Future<void> _loadMockData() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
    
    _exhibitions.value = [
      Exhibition(
        id: '1',
        title: 'Pameran Hidroponik Modern',
        description: 'Pameran teknologi hidroponik terkini untuk urban farming. Menampilkan sistem otomatis, nutrisi terbaik, dan hasil panen maksimal.',
        location: 'Jakarta Convention Center',
        imageUrl: 'https://images.unsplash.com/photo-1592921870789-04563d55041c?w=800&auto=format&fit=crop',
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
        description: 'Event terbesar untuk para pecinta pertanian organik. Workshop, seminar, dan showcase produk organik terbaik.',
        location: 'Bandung Creative Hub',
        imageUrl: 'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=800&auto=format&fit=crop',
        startDate: DateTime(2024, 4, 20),
        endDate: DateTime(2024, 4, 22),
        latitude: -6.9175,
        longitude: 107.6191,
        organizer: 'Green Agriculture Foundation',
        tags: ['organik', 'workshop', 'seminar'],
        isFeatured: true,
        ticketPrice: 75000,
      ),
      Exhibition(
        id: '3',
        title: 'Growana Future Farm',
        description: 'Eksibisi pertanian masa depan dengan konsep smart farming dan IoT. Pengalaman interaktif untuk semua usia.',
        location: 'Surabaya Expo Center',
        imageUrl: 'https://images.unsplash.com/photo-1530836369250-ef72a3f5cda8?w=800&auto=format&fit=crop',
        startDate: DateTime(2024, 5, 1),
        endDate: DateTime(2024, 5, 3),
        latitude: -7.2575,
        longitude: 112.7521,
        organizer: 'Growana Community',
        tags: ['smart farming', 'iot', 'interaktif'],
        isFeatured: false,
        ticketPrice: 0,
      ),
      Exhibition(
        id: '4',
        title: 'Urban Farming Festival',
        description: 'Festival tahunan untuk komunitas urban farming. Kompetisi tanaman, bazaar produk, dan networking session.',
        location: 'Taman Menteng, Jakarta',
        imageUrl: 'https://images.unsplash.com/photo-1417733403748-83bbc7c05140?w=800&auto=format&fit=crop',
        startDate: DateTime(2024, 4, 5),
        endDate: DateTime(2024, 4, 7),
        latitude: -6.1950,
        longitude: 106.8320,
        organizer: 'Jakarta Urban Farming',
        tags: ['festival', 'komunitas', 'bazaar'],
        isFeatured: true,
        ticketPrice: 0,
      ),
      Exhibition(
        id: '5',
        title: 'Vertical Garden Workshop',
        description: 'Workshop praktis membuat vertical garden di lahan terbatas. Panduan lengkap dari ahli tanaman hias.',
        location: 'Mal Kota Kasablanka',
        imageUrl: 'https://images.unsplash.com/photo-1483794344563-d27a8d18014e?w=800&auto=format&fit=crop',
        startDate: DateTime(2024, 4, 18),
        endDate: DateTime(2024, 4, 18),
        latitude: -6.2245,
        longitude: 106.8412,
        organizer: 'Vertical Garden Indonesia',
        tags: ['workshop', 'vertical garden', 'tanaman hias'],
        isFeatured: false,
        ticketPrice: 150000,
      ),
      Exhibition(
        id: '6',
        title: 'Aquaponics Technology Showcase',
        description: 'Memperkenalkan sistem aquaponics yang mengintegrasikan ikan dan tanaman. Solusi pertanian berkelanjutan.',
        location: 'Bogor Botanical Garden',
        imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=800&auto=format&fit=crop',
        startDate: DateTime(2024, 4, 25),
        endDate: DateTime(2024, 4, 28),
        latitude: -6.5971,
        longitude: 106.7990,
        organizer: 'Aquaponics Research Center',
        tags: ['aquaponics', 'berkelanjutan', 'teknologi'],
        isFeatured: false,
        ticketPrice: 30000,
      ),
    ];
    
    notifyListeners();
  }

  // Refresh data
  Future<void> refresh() async {
    await fetchExhibitions();
  }
}