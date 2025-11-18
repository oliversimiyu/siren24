import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:siren24/Models/fare_summary.dart';
import 'package:siren24/Sheets/add_on_list.dart';
import 'package:siren24/Sheets/amb_list.dart';
import 'package:siren24/Sheets/date_picker.dart';
import 'package:siren24/Sheets/fare_summary.dart';
import 'package:siren24/state/api_calling.dart';
import '../my-globals.dart' as globals;

class Path_Navigate extends StatefulWidget {
  static String id = 'path_screen';
  final LatLng currentlocation;
  final LatLng destinationlocation;
  final String destinationname;
  const Path_Navigate(
      {Key? key,
      required this.currentlocation,
      required this.destinationlocation,
      required this.destinationname})
      : super(key: key);

  @override
  _Path_NavigateState createState() => _Path_NavigateState();
}

class _Path_NavigateState extends State<Path_Navigate> {
  String Ambulanceid = " ";
  Color color1 = Color(0xffF7F7F7);
  Color color2 = Color(0xffF7F7F7);
  Color color3 = Color(0xffF7F7F7);
  Color color4 = Color(0xffF7F7F7);
  late GoogleMapController _Pathmapcontroller;
  List<Marker> pathMarkers = [];
  MapsRoutes route = new MapsRoutes();
  DistanceCalculator distanceCalculator = new DistanceCalculator();
  String googleApiKey = 'AIzaSyASODipwXRfzJNuFRN8lCaQeMnxLXSOvgQ';
  String totalDistance = 'No route';
  changeMapMode() {
    getJsonFile("assets/light.json").then(setMapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    _Pathmapcontroller.setMapStyle(mapStyle);
  }

  bool isMapCreated = false;
  int selected = 0;
  String cancelreply = "";
  @override
  Widget build(BuildContext context) {
    if (isMapCreated) {
      changeMapMode();
    }
    return Scaffold(
      body: GoogleMap(
        gestureRecognizers: Set()
          ..add(Factory<OneSequenceGestureRecognizer>(
              () => new EagerGestureRecognizer()))
          ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
          ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
          ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
          ..add(Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer())),
        initialCameraPosition:
            CameraPosition(target: widget.currentlocation, zoom: 15),
        mapType: MapType.normal,
        zoomControlsEnabled: false,
        markers: Set.from(pathMarkers),
        polylines: route.routes,
        onMapCreated: (controller) async {
          isMapCreated = true;
          List<LatLng> points = [
            widget.currentlocation,
            widget.destinationlocation,
          ];
          await route.drawRoute(
              points, 'Test routes', Color(0Xff4C6EE5), googleApiKey,
              travelMode: TravelModes.driving);
          setState(() {
            _Pathmapcontroller = controller;
            totalDistance =
                distanceCalculator.calculateRouteDistance(points, decimals: 1);
            // globals.totaldistance = (totalDistance);

            String distancestring =
                totalDistance.substring(0, totalDistance.length - 3);

            globals.totaldistance = distancestring;

            addCurrentLocation();
            adddestination();
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAmbulance();
        },
        child: Icon(Icons.directions_car),
      ),
    );
  }

  void adddestination() {
    setState(() {
      pathMarkers.add(
        Marker(
            markerId: MarkerId('destinationlocation'),
            position: widget.destinationlocation,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRose)),
      );
    });
  }

  void _showAmbulance() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AmbulanceList(
          controller: DraggableScrollableController(),
          destinationname: widget.destinationname,
          ambulanceid: Ambulanceid,
          next: () {
            // _fareSummary();
            addonsSheet();
          },
        );
      },
    );
  }

  Future<void> _fareSummary() async {
    FareKiSummary fare = await ApiCaller().GetFareSummary();
    globals.drivername = fare.driverName!;
    globals.driverphone = fare.driverPhoneno!;
    globals.drrating = fare.driverRating!;
    globals.vhno = fare.carNo!;
    globals.drimage = fare.driverImg!;
    globals.amount = fare.totalPrice!;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FareSummary(
          farecontroller: DraggableScrollableController(),
          total: fare.totalPrice,
          ambprice: fare.price,
          addonsprice: fare.addons,
          destinationname: widget.destinationname,
          dates: () {
            DateSheet();
          },
        );
      },
    );
  }

  Future<void> DateSheet() async {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) {
        return Date_select();
      },
    );
  }

  void addonsSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return AddOnList(
          addoncontroller: DraggableScrollableController(),
          ambid: Ambulanceid,
          addnext: () {
            _fareSummary();
          },
        );
      },
    );
  }

  void addCurrentLocation() {
    setState(() {
      pathMarkers.add(
        Marker(
            markerId: MarkerId('myLocation'),
            position: widget.currentlocation,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRose)),
      );
    });

    CameraPosition cameraposition =
        CameraPosition(target: widget.currentlocation, zoom: 11);
    _Pathmapcontroller.animateCamera(
      CameraUpdate.newCameraPosition(cameraposition),
    );
  }
}
