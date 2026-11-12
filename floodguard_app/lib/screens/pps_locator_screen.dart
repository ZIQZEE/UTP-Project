import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../data/pps_data.dart';
import '../localization/app_strings.dart';
import '../widgets/fade_slide_in.dart';
import 'pps_detail_screen.dart';

class PpsLocatorScreen extends StatefulWidget {
  const PpsLocatorScreen({super.key});

  @override
  State<PpsLocatorScreen> createState() => _PpsLocatorScreenState();
}

class _PpsLocatorScreenState extends State<PpsLocatorScreen> {
  final MapController _mapController = MapController();
  Position? _userPosition;
  bool _isLoadingLocation = true;
  String? _locationError;
  List<PpsCentre> _sortedCentres = [];

  // Default center: roughly the middle of Peninsular Malaysia
  static const LatLng _defaultCenter = LatLng(4.2105, 101.9758);

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  double _distanceKm(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  Future<void> _loadLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('error_location_services_off');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('error_location_permission_denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        throw Exception('error_location_permission_denied_forever');
      }

      final position = await Geolocator.getCurrentPosition();

      final sorted = List<PpsCentre>.from(ppsCentres);
      sorted.sort((a, b) {
        final distA = _distanceKm(position.latitude, position.longitude, a.latitude, a.longitude);
        final distB = _distanceKm(position.latitude, position.longitude, b.latitude, b.longitude);
        return distA.compareTo(distB);
      });

      setState(() {
        _userPosition = position;
        _sortedCentres = sorted;
        _isLoadingLocation = false;
      });

      // Note: do NOT call _mapController.move() here — the FlutterMap
      // widget hasn't rendered yet at this point (setState above just
      // triggers a rebuild), and calling move() before the first frame
      // throws. initialCenter already handles centering on first build.
    } catch (e) {
      setState(() {
        _locationError = e.toString().replaceFirst('Exception: ', '');
        _sortedCentres = List<PpsCentre>.from(ppsCentres);
        _isLoadingLocation = false;
      });
    }
  }

  Color _severityColor(String severity) {
    switch (severity) {
      case 'Critical':
        return Colors.red;
      case 'High':
        return Colors.deepOrange;
      case 'Moderate':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'evacuation_centres_title'))),
      body: _isLoadingLocation
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_locationError != null)
                  Container(
                    width: double.infinity,
                    color: Colors.amber.shade100,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      '${tr(context, 'showing_all_centres_notice')} (${tr(context, _locationError!)})',
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                Expanded(
                  flex: 3,
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _userPosition != null
                          ? LatLng(_userPosition!.latitude, _userPosition!.longitude)
                          : _defaultCenter,
                      initialZoom: _userPosition != null ? 11 : 6,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.floodguard_app',
                      ),
                      MarkerLayer(
                        markers: [
                          if (_userPosition != null)
                            Marker(
                              point: LatLng(_userPosition!.latitude, _userPosition!.longitude),
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.my_location, color: Colors.blue, size: 32),
                            ),
                          ..._sortedCentres.map(
                            (centre) => Marker(
                              point: LatLng(centre.latitude, centre.longitude),
                              width: 36,
                              height: 36,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PpsDetailScreen(
                                        centre: centre,
                                        distanceKm: _userPosition != null
                                            ? _distanceKm(
                                                _userPosition!.latitude,
                                                _userPosition!.longitude,
                                                centre.latitude,
                                                centre.longitude,
                                              )
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                                child: Icon(
                                  Icons.location_on,
                                  color: _severityColor(centre.nearbySeverity),
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemCount: _sortedCentres.length,
                    itemBuilder: (context, index) {
                      final centre = _sortedCentres[index];
                      final distance = _userPosition != null
                          ? _distanceKm(
                              _userPosition!.latitude,
                              _userPosition!.longitude,
                              centre.latitude,
                              centre.longitude,
                            )
                          : null;

                      return FadeSlideIn(
                        index: index,
                        staggerStep: const Duration(milliseconds: 30),
                        child: ListTile(
                          leading: Icon(Icons.location_on, color: _severityColor(centre.nearbySeverity)),
                          title: Text(centre.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Text('${centre.district}, ${centre.state}'),
                          trailing: distance != null
                              ? Text('${distance.toStringAsFixed(1)} km')
                              : null,
                          onTap: () {
                            _mapController.move(LatLng(centre.latitude, centre.longitude), 14);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PpsDetailScreen(
                                  centre: centre,
                                  distanceKm: distance,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}