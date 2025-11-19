import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siren24/Models/user_details.dart';

import 'package:siren24/Sheets/bottom_sheet1.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:siren24/basescreen/path.dart';
import 'package:siren24/profile/history.dart';
import 'package:siren24/profile/inviteFriends.dart';
import 'package:siren24/profile/notification.dart';
import 'package:siren24/profile/settings.dart';

import 'package:siren24/signup/signin.dart';
import 'package:siren24/state/api_calling.dart';
import 'package:siren24/services/user_storage.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:uuid/uuid.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
// import 'package:google_map_polyline_new/google_map_polyline_new.dart'; // Package not available
import 'package:google_place/google_place.dart';
import '../my-globals.dart' as globals;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.showScaffold = true}) : super(key: key);
  static String id = 'home_screen';
  final bool showScaffold;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isMapCreated = false;
  late LatLng latlangposition;
  late LatLng destination_location;
  late String destination;
  // load image for marker
  Future<Uint8List> getBytesFromAsset(String path) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: pixelRatio.round() * 40);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  //
  void subscribeToNotifications() async {
    String phone = '';
    final SharedPreferences pref = await SharedPreferences.getInstance();
    phone = pref.getString('phone_number')!;
    await FirebaseMessaging.instance.subscribeToTopic(phone);
    await FirebaseMessaging.instance.subscribeToTopic("all");
    await FirebaseMessaging.instance.subscribeToTopic("user");
  }

  List<Marker> myMarkers = [];
  // marker list
  late GoogleMapController _controller;
  // map controller
  late Position currentPosition;
  var geolocator = Geolocator();
  // current position
  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    latlangposition = LatLng(position.latitude, position.longitude);
    // get my location
    globals.currlat = position.latitude;
    globals.currentlng = position.longitude;

    setState(() {
      myMarkers.add(
        Marker(
            markerId: MarkerId('myLocation'),
            position: latlangposition,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRose)),
      );
    });
    ApiCaller().UserLocationUpdate(position.latitude, position.longitude);
    CameraPosition cameraposition =
        CameraPosition(target: latlangposition, zoom: 16);
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(cameraposition),
    );
  }

  final CameraPosition _initialPosition =
      CameraPosition(target: LatLng(-1.286389, 36.817223), zoom: 12);
  //initial position - Nairobi, Kenya

  final _textcontroller = TextEditingController();
  final _destinationFocusNode = FocusNode();
  //text controller
  @override
  void dispose() {
    _controller.dispose();
    _textcontroller.dispose();
    _destinationFocusNode.dispose();
    super.dispose();
  }

  late String searchAddr;

  var uuid = Uuid();
  String _sessionToken = "";
  List<dynamic> _placeList = [];
  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      LoadDetails();
    });
    subscribeToNotifications();
    loadimage();
    super.initState();
    _textcontroller.addListener(() {
      _onChanged();
    });
  }

  int flag = 1;
  _onChanged() {
    if (_sessionToken.isEmpty) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    if (flag == 1) {
      getSuggestion(_textcontroller.text);
    }
  }

  String kPLACES_API_KEY = "AIzaSyASODipwXRfzJNuFRN8lCaQeMnxLXSOvgQ";

  void getSuggestion(String input) async {
    if (input.length > 1) {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request =
          '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
      var response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    }
  }

  double ht = 0.6; // Increased from 0.3 to 0.6 for better accessibility

  DetailsResponse? detailsResponse;

  int bottomsheet = -1;
  changeMapMode() {
    getJsonFile("assets/light.json").then(setMapStyle);
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    _controller.setMapStyle(mapStyle);
  }

  int sug = 1;
  int dest = 0;
  int showsheet = 1;
  String _imagelink =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBSosYcX8VPrpuos_y96aBACA795fmUqppmQ&usqp=CAU";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String name = "User Name";
  String userPhone = "";
  String userEmail = "";

  Future<void> loadimage() async {
    final SharedPreferences SharedPrefrences =
        await SharedPreferences.getInstance();
    String? profilePic = SharedPrefrences.getString('profilepic');
    if (profilePic != null) {
      _imagelink = profilePic;
    }
  }

  LoadDetails() async {
    try {
      // Load user details from local storage
      Map<String, dynamic>? currentUser =
          await UserStorageService.getCurrentUser();

      if (currentUser != null) {
        setState(() {
          name = currentUser['name'] ?? 'User Name';
          userPhone = currentUser['phone'] ?? '';
          userEmail = currentUser['email'] ?? '';
        });
      } else {
        // Fallback to API if no local user found
        try {
          Timer(Duration(seconds: 5), () async {
            GetProfileDetails details = await ApiCaller().ProfileDetails();
            setState(() {
              name = details.name!;
            });
          });
        } catch (e) {
          print('Error loading profile from API: $e');
        }
      }
    } catch (e) {
      print('Error loading user details: $e');
    }
  }

  // Method to refresh user data - can be called when user profile is updated
  Future<void> refreshUserData() async {
    await LoadDetails();
  }

  // Build quick action card widget
  Widget _buildQuickActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isMapCreated) {
      changeMapMode();
    }

    Widget body = Stack(
      children: [
        GoogleMap(
          gestureRecognizers: Set()
            ..add(Factory<OneSequenceGestureRecognizer>(
                () => new EagerGestureRecognizer()))
            ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
            ..add(
                Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
            ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
            ..add(Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer())),
          initialCameraPosition: _initialPosition,
          mapType: MapType.normal,
          zoomControlsEnabled: false,
          markers: Set.from(myMarkers),
          onMapCreated: (controller) async {
            isMapCreated = true;
            await Geolocator.requestPermission();
            setState(() {
              _controller = controller;
              locatePosition();
            });
          },
        ),
        // Top search bar - Bolt-like design
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: dest == 1
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showsheet = 1;
                              dest = 0;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Going to',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                _textcontroller.text.length > 35
                                    ? _textcontroller.text.substring(0, 35) +
                                        '...'
                                    : _textcontroller.text,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.menu,
                            color: Colors.grey.shade700,
                            size: 20,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              showsheet = 1;
                              ht = 0.6; // Keep consistent height
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16, horizontal: 16),
                            child: Text(
                              'Where do you need an ambulance?',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xffEE2417).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.local_hospital,
                          color: Color(0xffEE2417),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        // Quick action buttons - Bolt-like
        if (dest == 0 && showsheet != 1)
          Positioned(
            top: 90,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionCard(
                        title: 'Book Now',
                        subtitle: 'Emergency ambulance',
                        icon: Icons.local_hospital,
                        color: Color(0xffEE2417),
                        onTap: () {
                          setState(() {
                            showsheet = 1;
                            ht = 0.6;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionCard(
                        title: 'Schedule',
                        subtitle: 'Book for later',
                        icon: Icons.schedule,
                        color: Color(0Xff4C6EE5),
                        onTap: () {
                          setState(() {
                            showsheet = 1;
                            ht = 0.6;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionCard(
                        title: 'History',
                        subtitle: 'View past rides',
                        icon: Icons.history,
                        color: Colors.orange,
                        onTap: () {
                          Navigator.pushNamed(context, History.id);
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionCard(
                        title: 'Emergency',
                        subtitle: 'Call help center',
                        icon: Icons.emergency,
                        color: Colors.red.shade700,
                        onTap: () {
                          ApiCaller().launchPhoneDialer('9718459379');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        if (showsheet == 1)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height:
                  MediaQuery.of(context).size.height * 0.35, // Reduced height
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Remove the drag indicator since it's now fixed
                      SizedBox(height: 10),
                      Text(
                        'Book Ambulance',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 24),
                      // Modern pickup location card
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0xffEE2417).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.my_location,
                                color: Color(0xffEE2417),
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PICKUP LOCATION',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'My current location',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      // Modern destination input card
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Color(0Xff4C6EE5).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.location_on,
                                color: Color(0Xff4C6EE5),
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DESTINATION',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  TextField(
                                    controller: _textcontroller,
                                    focusNode: _destinationFocusNode,
                                    autofocus:
                                        true, // Auto-focus when sheet opens
                                    onTap: () {
                                      setState(() {
                                        sug = 0;
                                      });
                                    },
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      hintText: "Where to?",
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_textcontroller.text.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  _textcontroller.clear();
                                  _placeList.clear();
                                  setState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.grey.shade600,
                                    size: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      // Modern suggestions list
                      if (_placeList.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _placeList.length,
                            separatorBuilder: (context, index) => Divider(
                              height: 1,
                              color: Colors.grey.shade100,
                            ),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () async {
                                  setState(() {
                                    flag = 0;
                                    _textcontroller.text = "";
                                    _textcontroller.text =
                                        _placeList[index]["description"];
                                    //   _placeList[index]["place_id"];
                                    destination =
                                        _placeList[index]["description"];
                                  });
                                  var googlePlace =
                                      GooglePlace(kPLACES_API_KEY);
                                  detailsResponse = await googlePlace.details
                                      .get(_placeList[index]["place_id"],
                                          fields: "geometry");
                                  var lat = detailsResponse!
                                      .result!.geometry!.location?.lat;
                                  var lng = detailsResponse!
                                      .result!.geometry!.location?.lng;
                                  globals.destilat = lat;
                                  globals.destilng = lng;
                                  destination_location = LatLng(lat!, lng!);
                                  setState(() {
                                    myMarkers.add(
                                      Marker(
                                          markerId: MarkerId('destination'),
                                          position: LatLng(lat, lng),
                                          icon: BitmapDescriptor
                                              .defaultMarkerWithHue(
                                                  BitmapDescriptor.hueRose)),
                                    );

                                    _placeList.clear();
                                    dest = 1;
                                  });
                                  showsheet = 0;

                                  CameraPosition cameraposition =
                                      CameraPosition(
                                          target: LatLng(lat, lng), zoom: 16);
                                  _controller.animateCamera(
                                    CameraUpdate.newCameraPosition(
                                        cameraposition),
                                  );
                                  Timer(Duration(seconds: 4), () {
                                    _showSheet('oh');
                                  });
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  _placeList.clear();
                                  flag = 1;
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.location_on,
                                          color: Colors.grey.shade600,
                                          size: 18,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _placeList[index][
                                                          "structured_formatting"]
                                                      ?["main_text"] ??
                                                  _placeList[index]
                                                      ["description"],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            if (_placeList[index][
                                                        "structured_formatting"]
                                                    ?["secondary_text"] !=
                                                null)
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 2),
                                                child: Text(
                                                  _placeList[index][
                                                          "structured_formatting"]
                                                      ["secondary_text"],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.grey.shade400,
                                        size: 14,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          )
      ],
    );

    if (widget.showScaffold) {
      return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: SideDrawer(),
          body: body,
          floatingActionButton: Container(
            margin: EdgeInsets.only(bottom: showsheet == 1 ? 300 : 80),
            child: FloatingActionButton(
              onPressed: () {
                locatePosition();
              },
              backgroundColor: Color(0xffEE2417),
              elevation: 8,
              child: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
      );
    } else {
      return SafeArea(
        child: Stack(
          children: [
            body,
            Positioned(
              bottom: 100,
              right: 16,
              child: Container(
                margin: EdgeInsets.only(bottom: showsheet == 1 ? 300 : 0),
                child: FloatingActionButton(
                  onPressed: () {
                    locatePosition();
                  },
                  backgroundColor: Color(0xffEE2417),
                  elevation: 8,
                  child: Icon(
                    Icons.my_location,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Drawer SideDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          Container(
            height: 300,
            color: Color(0Xff4C6EE5),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(_imagelink),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (userPhone.isNotEmpty)
                    Text(
                      userPhone,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  if (userEmail.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        userEmail,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.grey,
            ),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.history,
              color: Colors.grey,
            ),
            title: Text('History'),
            onTap: () {
              Navigator.pushNamed(context, History.id);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.notifications,
              color: Colors.grey,
            ),
            title: Text('Notifications'),
            onTap: () {
              Navigator.pushNamed(context, Notifications.id);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.call,
              color: Colors.grey,
            ),
            title: Text('Call Help Center'),
            onTap: () {
              ApiCaller().launchPhoneDialer('9718459379');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.wallet_giftcard,
              color: Colors.grey,
            ),
            title: Text('Invite Friends'),
            onTap: () {
              Navigator.pushNamed(context, InviteFriends.id);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.grey,
            ),
            title: Text('Settings'),
            onTap: () {
              Navigator.pushNamed(context, Settings.id);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.grey,
            ),
            title: Text('Logout'),
            onTap: () async {
              // Clear session data while preserving registered users
              await UserStorageService.clearSessionData();

              // Navigate back to sign in page
              Navigator.pushNamedAndRemoveUntil(
                  context, Sign_in.id, (route) => false);
            },
          ),
        ],
      ),
    );
  }

  void _showSheet(String destination) {
    showFlexibleBottomSheet<void>(
      minHeight: 0.1,
      initHeight: 0.1,
      maxHeight: 0.5,
      context: context,
      builder: (context, controller, offset) {
        return SingleChildScrollView(
          controller: controller,
          child: BottomSheetWidget1(
            // scrollController: controller,
            // bottomSheetOffset: offset,
            end: destination,
            proceed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Path_Navigate(
                      currentlocation: latlangposition,
                      destinationlocation: destination_location,
                      destinationname: _textcontroller.text.substring(0, 30),
                    ),
                  ));
            },
          ),
        );
      },
      anchors: [0.1, 0.5],
    );
  }
/*
  void _showSecondSheet() {
    showFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: 0.5,
      maxHeight: 1,
      context: context,
      builder: (context, controller, offset) {
        return Bottomsheet2(
          booknow: () {
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.pushNamed(context, SearchScreen.id);
          },
        );
      },
      anchors: [0, 0.5, 1],
    );
  }

  void _AvailableAmbulancesSheet() {
    showFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: 0.66,
      maxHeight: 1,
      context: context,
      builder: (context, controller, offset) {
        return AvailableAmbulance();
      },
      anchors: [0, 0.5, 1],
    );
  }
  */
}
