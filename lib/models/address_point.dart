class AddressPoint {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  AddressPoint({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

Future<List<AddressPoint>> getAddressListFromFakeDatabase() async {
  await Future.delayed(Duration(seconds: 1));
  return [
    AddressPoint(id: '1', name: 'Ankara AFAD', latitude: 39.925, longitude: 32.8369),
    AddressPoint(id: '2', name: 'İstanbul AFAD', latitude: 41.0082, longitude: 28.9784),
    AddressPoint(id: '3', name: 'İzmir AFAD', latitude: 38.4192, longitude: 27.1287),
    AddressPoint(id: '4', name: 'Kocaeli AFAD', latitude: 40.9892, longitude: 29.9385),
  ];
}