import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MyPosition {
  final double latitude;
  final double longitude;

  MyPosition({required this.latitude, required this.longitude});
}

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;

  LocationService._internal();

  Future<MyPosition?> getCurrentLocation() async {
    // check and request location permission
    bool permissionGranted = await _handlePermission();
    if (!permissionGranted) {
      print("❌ Konum izni verilmedi.");
      return null;
    }

    try {
      // get current position with high accuracy
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final now = DateTime.now();
      print('[Konum Alındı] 📍 $now → ${position.latitude}, ${position.longitude}');
      return MyPosition(latitude: position.latitude, longitude: position.longitude);
    } catch (e) {
      print("❌ Konum alınamadı: $e");
      return null;
    }
  }

  Future<String> getAddressFromPosition(MyPosition position) async {
    try {
      // reverse geocode to get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) return "Adres bulunamadı";

      Placemark place = placemarks.first;

      return [
        place.name,
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.postalCode,
        place.country,
      ].where((element) => element != null && element.isNotEmpty).join(', ');
    } catch (e) {
      print('Adres alma hatası: $e');
      return "Adres bilgisi alınamadı";
    }
  }

  Future<bool> _handlePermission() async {
    // check if location service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('⚠️ Konum servisi kapalı');
      return false;
    }

    // check location permission status
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // request permission if denied
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    // if permission is denied forever, cannot request again
    if (permission == LocationPermission.deniedForever) {
      print('🚫 Kullanıcı konum iznini tamamen reddetti.');
      return false;
    }

    return true;
  }
}