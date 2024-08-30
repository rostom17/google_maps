import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class GeolocatorScreen extends StatefulWidget {
  const GeolocatorScreen({super.key});

  @override
  State<GeolocatorScreen> createState() => _GeolocatorScreenState();
}

class _GeolocatorScreenState extends State<GeolocatorScreen> {
  late GoogleMapController mapController;
  Position? _currentPosition;
  LatLng _initialCamreaPosition =
      const LatLng(23.732073370001892, 90.42625668585991);
  List<LatLng> _traveledDistaceList = [];
  Set<Marker> _markers = {};
  Set<Polyline> _polyLine = {};
  final uuid = Uuid();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    _traveledDistaceList.clear();

    super.initState();
    //_getCurrentLocation();
    _listenCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.pink.shade300,
        title: const Text("GeoLocator"),
      ),
      body: GoogleMap(
        initialCameraPosition:
            CameraPosition(target: _initialCamreaPosition, zoom: 14),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: _onMapCreated,
        markers: _markers,
        polylines: _polyLine,
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    debugPrint("\n\nexecutning get current location\n\n");
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      bool isEnabled = await Geolocator.isLocationServiceEnabled();

      if (isEnabled) {
        _currentPosition = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 10,
          timeLimit: Duration(seconds: 10),
        ));

        if (_currentPosition != null) {
          setState(() {
            debugPrint(_currentPosition.toString());
            _initialCamreaPosition =
                LatLng(_currentPosition!.latitude, _currentPosition!.latitude);
          });
          _markers.add(
            Marker(
                markerId: MarkerId("myCurrentLoaction"),
                position: LatLng(
                    _currentPosition!.latitude, _currentPosition!.longitude),
                infoWindow: InfoWindow(
                    title: "My Current Location",
                    snippet:
                        "${_currentPosition!.latitude} , ${_currentPosition!.latitude}")),
          );
          mapController.animateCamera(CameraUpdate.newLatLngZoom(
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
              14));
        }
      } else {
        Geolocator.openLocationSettings();
        _getCurrentLocation();
      }
    } else {
      if (permission == LocationPermission.deniedForever) {
        Geolocator.openAppSettings();
        _getCurrentLocation();
        return;
      }

      LocationPermission requestPermission =
          await Geolocator.requestPermission();
      if (requestPermission == LocationPermission.always ||
          requestPermission == LocationPermission.whileInUse) {
        _getCurrentLocation();
      }
    }
  }

  Future<void> _listenCurrentLocation() async {
    debugPrint("\n\nexecutning listenLocation\n\n");
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      final bool isEnable = await Geolocator.isLocationServiceEnabled();
      if (isEnable) {
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
          ),
        ).listen((myCurrentPosition) {
          setState(() {
            _traveledDistaceList.add(LatLng(
                myCurrentPosition.latitude, myCurrentPosition.longitude));
            if(_markers.isNotEmpty) {
              _markers.clear();
            }
            _markers.add(Marker(
                markerId: MarkerId(uuid.v4()),
                position: LatLng(
                    myCurrentPosition.latitude, myCurrentPosition.longitude),
                infoWindow: InfoWindow(
                    title: "My current Position",
                    snippet:
                        "${myCurrentPosition.latitude} , ${myCurrentPosition.longitude}")));

            mapController.animateCamera(CameraUpdate.newLatLngZoom(
                LatLng(myCurrentPosition.latitude, myCurrentPosition.longitude),
                16));

            _traveledDistaceList.add(LatLng(
                myCurrentPosition.latitude, myCurrentPosition.longitude));
            _polyLine.add(Polyline(
                polylineId: PolylineId(uuid.v4()),
                color: Colors.deepPurple,
                width: 10,
                points: _traveledDistaceList,
            ));
          });
        });
      } else {
        // ON gps service
        Geolocator.openLocationSettings();
      }
    } else {
      // Permission denied
      if (permission == LocationPermission.deniedForever) {
        Geolocator.openAppSettings();
        return;
      }
      LocationPermission requestPermission =
          await Geolocator.requestPermission();
      if (requestPermission == LocationPermission.always ||
          requestPermission == LocationPermission.whileInUse) {
        _listenCurrentLocation();
      }
    }
  }
}
