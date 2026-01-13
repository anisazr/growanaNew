// lib/models/exhibition_model.dart - FIXED
import 'dart:ui'; // TAMBAH IMPORT INI

class Exhibition {
  final String id;
  final String title;
  final String description;
  final String location;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final double latitude;
  final double longitude;
  final String organizer;
  final List<String> tags;
  final bool isFeatured;
  final int ticketPrice; // in IDR

  Exhibition({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.latitude,
    required this.longitude,
    required this.organizer,
    this.tags = const [],
    this.isFeatured = false,
    this.ticketPrice = 0,
  });

  // Factory method untuk parse dari JSON API
  factory Exhibition.fromJson(Map<String, dynamic> json) {
    return Exhibition(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Tanpa Judul',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/400x300',
      startDate: DateTime.parse(json['startDate'] ?? DateTime.now().toString()),
      endDate: DateTime.parse(json['endDate'] ?? DateTime.now().toString()),
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      organizer: json['organizer'] ?? 'Unknown',
      tags: List<String>.from(json['tags'] ?? []),
      isFeatured: json['isFeatured'] ?? false,
      ticketPrice: (json['ticketPrice'] as num?)?.toInt() ?? 0,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'location': location,
      'imageUrl': imageUrl,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'organizer': organizer,
      'tags': tags,
      'isFeatured': isFeatured,
      'ticketPrice': ticketPrice,
    };
  }

  // Format tanggal untuk display
  String get formattedDate {
    final start = '${startDate.day}/${startDate.month}/${startDate.year}';
    final end = '${endDate.day}/${endDate.month}/${endDate.year}';
    return '$start - $end';
  }

  // Format harga tiket
  String get formattedTicketPrice {
    if (ticketPrice == 0) return 'Gratis';
    return 'Rp ${ticketPrice.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  // Check jika event masih berlangsung
  bool get isOngoing {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  // Check jika event akan datang
  bool get isUpcoming {
    return DateTime.now().isBefore(startDate);
  }

  // Days remaining/elapsed
  int get daysStatus {
    final now = DateTime.now();
    if (isUpcoming) {
      return startDate.difference(now).inDays;
    } else if (isOngoing) {
      return endDate.difference(now).inDays;
    } else {
      return now.difference(endDate).inDays;
    }
  }

  // Status text
  String get statusText {
    if (isUpcoming) return 'Dimulai dalam $daysStatus hari';
    if (isOngoing) return 'Berakhir dalam $daysStatus hari';
    return 'Selesai $daysStatus hari lalu';
  }

  // Status color - FIXED
  Color get statusColor {
    if (isUpcoming) return const Color(0xFF2196F3); // Blue
    if (isOngoing) return const Color(0xFF4CAF50);  // Green
    return const Color(0xFF9E9E9E);                 // Grey
  }
}