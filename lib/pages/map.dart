import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';
import 'package:afet_acil_durum_app/pages/settings.dart';
import 'package:afet_acil_durum_app/pages/emergency_contact.dart';
import 'package:afet_acil_durum_app/pages/homepage.dart';
import 'package:afet_acil_durum_app/pages/notification_page.dart';
import 'package:afet_acil_durum_app/services/connectivity/connectivity_service.dart';
import 'package:afet_acil_durum_app/services/location/location_service.dart';
import 'package:afet_acil_durum_app/themes/theme_controller.dart';
import 'package:afet_acil_durum_app/models/address_point.dart';

class MapArea extends StatefulWidget {
  const MapArea({super.key});

  @override
  MapAreaState createState() => MapAreaState();
}

class MapAreaState extends State<MapArea> {
  final ConnectivityService _connectivityService = ConnectivityService();
  final MapController _mapController = MapController();
  MyPosition? _currentPosition;
  List<Marker> _markers = [];
  bool _isLoadingLocation = false;
  List<AddressPoint> _addressPoints = [];

  static const LatLng _ankaraCenter = LatLng(39.9208, 32.8541);
  LatLng _currentMapCenter = _ankaraCenter;
  double _currentZoom = 13.0;

  Future<void> fetchAddressMarkers() async {
    List<AddressPoint> addressList = await getAddressListFromFakeDatabase();

    List<Marker> addressMarkers = addressList.map((point) {
      return Marker(
        key: ValueKey(point.id),
        point: LatLng(point.latitude, point.longitude),
        width: 40,
        height: 40,
        child: Tooltip(
          message: point.name,
          child: Icon(
            Icons.location_pin,
            color: Colors.deepPurple,
            size: 40,
          ),
        ),
      );
    }).toList();

    setState(() {
      _addressPoints = addressList;
      _markers = addressMarkers;
    });
  }

  @override
  void initState() {
    super.initState();
    _connectivityService.baslat();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _connectivityService.kapat();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    await fetchAddressMarkers();

    setState(() {
      _isLoadingLocation = true;
    });

    final locationService = LocationService();

    try {
      final myPos = await locationService.getCurrentLocation();

      if (myPos == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Konum alınamadı veya izin verilmedi!'),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      setState(() {
        _currentPosition = myPos;
        _currentMapCenter = LatLng(myPos.latitude, myPos.longitude);

        _markers.removeWhere((marker) => marker.key == ValueKey('current_location'));

        List<Marker> addressMarkers = _addressPoints.map((address) {
          return Marker(
            key: ValueKey(address.id),
            point: LatLng(address.latitude, address.longitude),
            child: Tooltip(
              message: address.name,
              child: Icon(
                Icons.location_pin,
                color: Colors.blue,
                size: 35,
              ),
            ),
            width: 40,
            height: 40,
          );
        }).toList();

        _markers = [
          ...addressMarkers,
          Marker(
            key: ValueKey('current_location'),
            point: _currentMapCenter,
            child: Icon(
              Icons.location_on,
              color: Colors.red,
              size: 40,
            ),
            width: 40,
            height: 40,
          ),
        ];

        _isLoadingLocation = false;
      });

      _mapController.move(_currentMapCenter, 16.0);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Konum başarıyla alındı!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Konum alınamadı: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _zoomIn() {
    setState(() {
      _currentZoom = (_currentZoom + 1).clamp(1.0, 18.0);
    });
    _mapController.move(_currentMapCenter, _currentZoom);
  }

  void _zoomOut() {
    setState(() {
      _currentZoom = (_currentZoom - 1).clamp(1.0, 18.0);
    });
    _mapController.move(_currentMapCenter, _currentZoom);
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final isDark = themeController.isDarkMode;

    final backgroundColor = isDark ? Colors.grey[900] : Colors.grey[100];
    final headerTextColor = isDark ? Colors.white : Colors.grey[800];
    final containerColor = isDark ? Colors.blueGrey.shade700 : Colors.blueGrey.shade300;
    final containerShadowColor = isDark ? Colors.black54 : Colors.blueGrey.shade100.withOpacity(0.5);
    final iconColor = isDark ? Colors.white70 : Colors.white;
    final labelTextColor = isDark ? Colors.white : Colors.white;
    final navBarColor = isDark ? Colors.blueGrey.shade900 : Colors.blueGrey.shade700;

    return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Column(
              children: [
          Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: buildHeader(),
        ),
        Expanded(
        child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    const SizedBox(height: 20),
    Text(
    "KONUMUM VE ETRAFIMDAKİLER",
    style: TextStyle(
    color: headerTextColor,
    fontSize: 28,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.2,
    ),
    ),
    const SizedBox(height: 24),
    Container(
    decoration: BoxDecoration(
    color: containerColor,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
    BoxShadow(
    color: containerShadowColor,
    blurRadius: 12,
    offset: Offset(0, 6),
    ),
    ],
    ),
    child: Stack(
    children: [
    Container(
    height: 400,
    width: double.infinity,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(24),
    ),
    child: ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: FlutterMap(
    mapController: _mapController,
    options: MapOptions(
    initialCenter: _currentMapCenter,
    initialZoom: _currentZoom,
    minZoom: 1.0,
    maxZoom: 18.0,
    onPositionChanged: (MapPosition position, bool hasGesture) {
    if (hasGesture) {
    setState(() {
    _currentMapCenter = position.center!;
    _currentZoom = position.zoom!;
    });
    }
    },
    ),
    children: [
    TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'com.example.afet_acil_durum_app',
    maxZoom: 18,
    ),
    MarkerLayer(
    markers: _markers,
    ),
    ],
    ),
    ),
    ),
    if (_isLoadingLocation)
    Container(
    height: 400,
    decoration: BoxDecoration(
    color: Colors.black45,
    borderRadius: BorderRadius.circular(24),
    ),
    child: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
    ),
    const SizedBox(height: 16),
    Text(
    "Konum alınıyor...",
    style: TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    ),
    ),
    ],
    ),
    ),
    ),
    Positioned(
    right: 10,
    top: 10,
    child: Column(
    children: [
    Container(
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(5),
    boxShadow: [
    BoxShadow(
    color: Colors.black26,
    blurRadius: 2,
    ),
    ],
    ),
    child: Column(
    children: [
    GestureDetector(
    onTap: _zoomIn,
    child: Container(
    padding: EdgeInsets.all(8),
    child: Icon(Icons.add, size: 20, color: Colors.black87),
    ),
    ),
    Container(
    height: 1,
    color: Colors.grey[300],
    ),
    GestureDetector(
    onTap: _zoomOut,
    child: Container(
    padding: EdgeInsets.all(8),
    child: Icon(Icons.remove, size: 20, color: Colors.black87),
    ),
    ),
    ],
    ),
    ),
    ],
    ),
    ),
    ],
    ),
    ),
    const SizedBox(height: 24),
    Container(
    decoration: BoxDecoration(
    color: containerColor,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
    BoxShadow(
    color: containerShadowColor,
    blurRadius: 8,
    offset: Offset(0, 4),
    ),
    ],
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
    buildNavigationButton(
    icon: Icons.my_location,
    label: "Konum",
    onTap: _getCurrentLocation,
    iconBgColor: Colors.white.withOpacity(0.2),
    labelColor: labelTextColor,
    ),
    buildNavigationButton(
    icon: Icons.share,
    label: "Paylaş",
    onTap: () async {
    if (_currentPosition != null) {
    final locationService = LocationService();
    final myPos = MyPosition(
    latitude                                  : _currentPosition!.latitude,
      longitude: _currentPosition!.longitude,
    );

    String address = await locationService.getAddressFromPosition(myPos);

    final latitude = _currentPosition!.latitude.toStringAsFixed(6);
    final longitude = _currentPosition!.longitude.toStringAsFixed(6);
    final googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    Share.share(
      'Benim konumum:\n$address\n\nKoordinatlar: $latitude, $longitude\nHaritada görmek için: $googleMapsUrl',
    );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Önce konumunuzu alın!'),
          backgroundColor: Colors.orange,
        ),
      );
    }
    },
      iconBgColor: Colors.white.withOpacity(0.2),
      labelColor: labelTextColor,
    ),
      buildNavigationButton(
        icon: Icons.zoom_out,
        label: "Uzaklaştır",
        onTap: _zoomOut,
        iconBgColor: Colors.white.withOpacity(0.2),
        labelColor: labelTextColor,
      ),
      buildNavigationButton(
        icon: Icons.zoom_in,
        label: "Yakınlaştır",
        onTap: _zoomIn,
        iconBgColor: Colors.white.withOpacity(0.2),
        labelColor: labelTextColor,
      ),
    ],
    ),
    ),
      const SizedBox(height: 32),
      Center(
        child: GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Acil durum alarmı aktifleştirildi!'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.red.shade700,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.shade300.withOpacity(0.7),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.notifications_active,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ),
      const SizedBox(height: 24),
    ],
    ),
        ),
        ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: navBarColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        navIcon(
                          icon: Icons.settings,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Settings())),
                          iconColor: iconColor,
                        ),
                        navIcon(
                          icon: Icons.people,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EmergencyContact())),
                          iconColor: iconColor,
                        ),
                        navIcon(
                          icon: Icons.home,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Homepage())),
                          iconColor: iconColor,
                        ),
                        navIcon(
                          icon: Icons.notifications,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationPage())),
                          iconColor: iconColor,
                        ),
                        navIcon(
                          icon: Icons.map,
                          isActive: true,
                          onTap: () {},
                          iconColor: iconColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
          ),
        ),
    );
  }

  Widget buildNavigationButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color iconBgColor,
    required Color labelColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget navIcon({
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: isActive
            ? BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        )
            : null,
        child: Icon(
          icon,
          color: iconColor ?? (isActive ? Colors.white : Colors.white70),
          size: 28,
        ),
      ),
    );
  }

  Widget buildHeader() {
    return StreamBuilder<BaglantiDurumu>(
      stream: _connectivityService.baglantiStream,
      initialData: _connectivityService.mevcutDurum,
      builder: (context, snapshot) {
        final themeController = Provider.of<ThemeController>(context);
        final isDark = themeController.isDarkMode;
        final borderColor = _connectivityService.baglantiRengi();
        final bgColor = borderColor.withOpacity(0.1);
        final textColor = isDark ? Colors.white : borderColor;

        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: borderColor,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _connectivityService.baglantiIkonu(),
                    color: borderColor,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _connectivityService.baglantiTipiMetni(),
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}