import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(23.875796821455733, 90.32048643147368);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        zoomControlsEnabled: true,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center, zoom: 18),
        onTap: (LatLng ltln) {
          debugPrint(ltln.toString());
        },

        polylines: {
           Polyline(
            polylineId: const PolylineId("xyz"),
            color: Colors.pink,
            width: 20,
            jointType: JointType.mitered,
            onTap: (){},
            points: const [
              LatLng(23.8765586826378, 90.32132495194674),
              LatLng(23.877539744753612, 90.3194135427475),
              LatLng(23.875760951023512, 90.32038416713476),
            ]
          ),
        },

        circles: {
          const Circle(
            circleId: CircleId("abc"),
            center: LatLng(23.87709213608566, 90.32156601548195),
            radius: 100,
            fillColor: Colors.red,
            strokeColor: Colors.blue,
            strokeWidth: 20,
          )
        },

        polygons: {
          Polygon(
            polygonId: const PolygonId('gonPoly'),
            fillColor:  Colors.deepPurple.withOpacity(.3),
            strokeColor: Colors.green,
            strokeWidth: 20,
            points: const [
              LatLng(23.872606459909406, 90.32270427793264),
               LatLng(23.872907226737237, 90.32003313302994),
               LatLng(23.86941142073721, 90.31891733407974),
               LatLng(23.868744257419642, 90.32142754644156),
              LatLng(23.871533688540215, 90.3216028958559),
            ]
          )
        },

        markers: {
          Marker(
            markerId: MarkerId("idMarker"),
            position:  LatLng(23.873897820798348, 90.31644534319639),
            infoWindow: InfoWindow(
              title: "Mosque",
            ),

            draggable:  true,
            onDragStart: (latlang){
              debugPrint(latlang.toString());
            },
            onDragEnd: (latlang){
              debugPrint(latlang.toString());
            },
            onDrag: (latlang) {
              debugPrint(latlang.toString());
            }

          )
        },

      ),
    );
  }
}
