// lib/services/location_service.dart - FIXED WITH GEOCODING
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding; // IMPORT DENGAN ALIAS

class LocationService {
  /// Get current location once
  static Future<Position> getCurrentLocation() async {
    try {
      // Cek permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission permanently denied');
      }
      
      // Cek jika location service enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }
      
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
      rethrow;
    }
  }

  /// Calculate distance in kilometers
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  /// Get address from coordinates using geocoding package
  static Future<String> getAddressFromCoordinates(
    double lat,
    double lon,
  ) async {
    try {
      // Gunakan geocoding package
      final placemarks = await geocoding.placemarkFromCoordinates(lat, lon);
      
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        
        // Build address string
        final addressParts = <String>[];
        
        if (placemark.street != null && placemark.street!.isNotEmpty) {
          addressParts.add(placemark.street!);
        }
        
        if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
          addressParts.add(placemark.subLocality!);
        }
        
        if (placemark.locality != null && placemark.locality!.isNotEmpty) {
          addressParts.add(placemark.locality!);
        }
        
        if (placemark.administrativeArea != null && placemark.administrativeArea!.isNotEmpty) {
          addressParts.add(placemark.administrativeArea!);
        }
        
        if (placemark.country != null && placemark.country!.isNotEmpty) {
          addressParts.add(placemark.country!);
        }
        
        if (addressParts.isNotEmpty) {
          return addressParts.join(', ');
        }
      }
      
      // Fallback: return coordinates
      return 'Location: ${lat.toStringAsFixed(4)}, ${lon.toStringAsFixed(4)}';
    } catch (e) {
      print('Error getting address: $e');
      return 'Location: ${lat.toStringAsFixed(4)}, ${lon.toStringAsFixed(4)}';
    }
  }
}