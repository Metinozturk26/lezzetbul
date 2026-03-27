import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  /// Kullanicinin mevcut konumunu alir
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationException('Konum servisi kapali. Lutfen aciniz.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationException('Konum izni reddedildi.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationException(
          'Konum izni kalici olarak reddedildi. Ayarlardan izin veriniz.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Sehir adini koordinatlara cevirir
  Future<LocationResult> getLocationFromCity(String cityName) async {
    try {
      final locations = await locationFromAddress('$cityName, Turkiye');
      if (locations.isNotEmpty) {
        return LocationResult(
          lat: locations.first.latitude,
          lng: locations.first.longitude,
          cityName: cityName,
        );
      }
      throw LocationException('$cityName icin konum bulunamadi.');
    } catch (e) {
      if (e is LocationException) rethrow;
      throw LocationException('Konum aranamadi: $e');
    }
  }

  /// Koordinatlardan sehir adini alir
  Future<String> getCityFromCoordinates(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return place.administrativeArea ?? place.locality ?? 'Bilinmeyen';
      }
      return 'Bilinmeyen';
    } catch (e) {
      return 'Bilinmeyen';
    }
  }

  /// Iki nokta arasindaki mesafeyi hesaplar (metre cinsinden)
  double calculateDistance(
      double lat1, double lng1, double lat2, double lng2) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
  }
}

class LocationResult {
  final double lat;
  final double lng;
  final String cityName;

  LocationResult({
    required this.lat,
    required this.lng,
    required this.cityName,
  });
}

class LocationException implements Exception {
  final String message;
  LocationException(this.message);

  @override
  String toString() => message;
}
