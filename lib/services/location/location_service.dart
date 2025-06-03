import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPosition {
  final double latitude;
  final double longitude;
  MyPosition({required this.latitude, required this.longitude});
}

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  // get current location and save it to shared preferences
  Future<MyPosition?> getCurrentLocation() async {
    if (!await handlePermission()) return null;

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final myPos = MyPosition(latitude: position.latitude, longitude: position.longitude);
      String address = await getAddressFromPosition(myPos);
      print("Konum: ${position.latitude}, ${position.longitude}, Adres: $address");
      await _saveLocationToPrefs(myPos); // save to prefs
      return myPos;
    } catch (e) {
      print("Konum alınamadı: $e");
      return null;
    }
  }

  // save location to shared preferences
  Future<void> _saveLocationToPrefs(MyPosition position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('last_latitude', position.latitude);
    await prefs.setDouble('last_longitude', position.longitude);
    print('Konum kaydedildi.');
  }

  // retrieve last saved location from shared preferences
  Future<MyPosition?> getSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble('last_latitude');
    final lng = prefs.getDouble('last_longitude');
    if (lat != null && lng != null) return MyPosition(latitude: lat, longitude: lng);
    return null;
  }

  // convert coordinates to a readable address string
  Future<String> getAddressFromPosition(MyPosition position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
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
      ].where((e) => e != null && e.isNotEmpty).join(', ');
    } catch (e) {
      print('Adres alma hatası: $e');
      return "Adres bilgisi alınamadı";
    }
  }

  // handle location permission request logic
  Future<bool> handlePermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }
}