import 'package:flutter/material.dart';
import 'package:google_maps/screens/geolocator_screen.dart';
import 'package:google_maps/screens/home_screen.dart';

class GoogleMapsPractice extends StatelessWidget {
  const GoogleMapsPractice({super.key});

  @override
  Widget build (BuildContext context) {
    return const  MaterialApp(
      home: GeolocatorScreen(),
    );
  }
}