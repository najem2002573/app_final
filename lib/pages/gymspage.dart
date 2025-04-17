import 'package:app/services/gym.dart';
import 'package:app/services/manager.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Gymspage extends StatefulWidget {
  @override
  State<Gymspage> createState() => _GymspageState();
}

class _GymspageState extends State<Gymspage> {
  final _manager=BackendManager();
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  List<Gym> _gyms = [];
  Position? _pos;
  bool isMapView = true; // Track which view is currently selected

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _manager.getLocation();
    final pos = _manager.getPos();
    setState(() {
      _pos = pos;
    });

    await _manager.callPlacesApi(pos);
    final gyms = _manager.getGyms();
      print('Gyms fetched: $gyms'); // Log the gyms list
      setState(() {
          _gyms = gyms;
          _markers = gyms.map((gym) {
            return Marker(
              markerId: MarkerId(gym.name),
              position: LatLng(gym.lat, gym.long),
              infoWindow: InfoWindow(title: gym.name),
            );
          }).toSet();
        });
        print('Markers created: $_markers');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Gyms'),
      actions: [
          // Map and List toggle buttons inside the AppBar
          IconButton(
            icon: Icon(isMapView ? Icons.list : Icons.map),
            onPressed: () {
              setState(() {
                isMapView = !isMapView; // Toggle view
              });
            },
          ),
        ],
      
      
      ),
      body: _pos == null
          ? const Center(child: CircularProgressIndicator())
          : isMapView
              ? GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(_pos!.latitude, _pos!.longitude),
                    zoom: 14,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                )
              : ListView.builder(
                  itemCount: _gyms.length,
                  itemBuilder: (context, index) {
                    final gym = _gyms[index];
                    return ListTile(
                      title: Text(gym.name),
                      subtitle: Text('Lat: ${gym.lat}, Long: ${gym.long}'),
                    );
                  },
                ),
    );
  }
}