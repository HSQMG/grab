import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grab/controller/map_controller.dart';
import 'package:grab/data/model/socket_msg_model.dart';
import 'package:grab/presentations/screens/driver/end_ride_screen.dart';
import 'package:grab/presentations/screens/driver/finish_ride_screen.dart';
import 'package:grab/presentations/widget/confirm_button.dart';
import 'package:grab/presentations/widget/dashed_line_vertical_painter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grab/presentations/widget/profile_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final GlobalKey<ScaffoldState> jcbHomekey = GlobalKey();

class StartRideScreen extends StatefulWidget {
  IO.Socket? socket;
  SocketMsgModel? socketMsg;
  StartRideScreen({Key? key, required this.socket, required this.socketMsg})
      : super(key: key);

  @override
  State<StartRideScreen> createState() => _StartRideScreen();
}

class _StartRideScreen extends State<StartRideScreen> {
  final Completer<GoogleMapController> _mapController = Completer();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isContainerVisible = true;
  LatLng? currentPosition;
  Set<Marker> markers = {};
  Polyline? polyline;
  bool doesStartRoute = false;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    MapController()
        .getPolylinePoints(
          GeoPoint(widget.socketMsg!.pickupPoint!.latitude,
              widget.socketMsg!.pickupPoint!.longitude),
          GeoPoint(widget.socketMsg!.destinationPoint!.latitude,
              widget.socketMsg!.destinationPoint!.longitude),
        )
        .then((value) => MapController().generatePolylineFromPoint(value))
        .then((value) => {
              setState(() {
                polyline = value;
              })
            });

    setState(() {
      currentPosition = widget.socketMsg?.pickupPoint;
      markers.add(Marker(
        markerId: const MarkerId('pickup'),
        position: LatLng(currentPosition!.latitude, currentPosition!.longitude),
        infoWindow: const InfoWindow(title: 'Pickup Location'),
      ));
      markers.add(Marker(
        markerId: const MarkerId('destination'),
        position: LatLng(widget.socketMsg!.destinationPoint!.latitude,
            widget.socketMsg!.destinationPoint!.longitude),
        infoWindow: const InfoWindow(title: 'Destination Location'),
      ));
    });
  }

  void startRoute() async {
    GoogleMapController controller = await _mapController.future;
    List<LatLng> points = polyline!.points;

    int index = 0;

    void updateStateWithDelay() {
      if (index == points.length) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FinishRideScreen(
                      socketMsg: widget.socketMsg,
                      socket: widget.socket,
                    )));
      }
      if (index < points.length) {
        widget.socketMsg?.driverPosition = points[index];
        widget.socket?.emit('send_location', widget.socketMsg?.toJson());

        controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: points[index], zoom: 15)));
        setState(() {
          markers.add(Marker(
            markerId: const MarkerId('currentLocation'),
            position: points[index],
            infoWindow: const InfoWindow(title: 'Current Location'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          ));
        });

        Timer(const Duration(seconds: 5), () {
          index++;
          updateStateWithDelay();
        });
      }
    }

    updateStateWithDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: jcbHomekey,
      drawer: ProfileHomeScreen(),
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              alignment: Alignment.bottomCenter,
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      currentPosition!.latitude,
                      currentPosition!.longitude,
                    ),
                    zoom: 15,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                  },
                  markers: markers,
                  polylines: polyline != null ? {polyline!} : {},
                ),
                if (!doesStartRoute)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // IconButton to toggle visibility
                      Container(
                        decoration: BoxDecoration(
                          color: context.scaffoldBackgroundColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(
                            isContainerVisible
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isContainerVisible = !isContainerVisible;
                            });
                          },
                        ),
                      ),

                      // Visibility widget containing the container
                      Visibility(
                        visible:
                            isContainerVisible, // Control visibility based on the state variable
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(20))),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(
                                    10), // This adds 10 pixels of padding on all sides
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Customer name aligned to the left
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        widget.socketMsg?.distance
                                            as String, // Replace with your dynamic customer name
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),

                                    // Spacing between the text and the icons
                                    Expanded(
                                      child: Container(),
                                    ),

                                    // Icons aligned to the right
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Row(
                                        mainAxisSize: MainAxisSize
                                            .min, // To keep the icons together
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape
                                                  .circle, // Circular shape
                                              border: Border.all(
                                                color: Colors
                                                    .grey, // Black border color
                                                width: 2, // Border width
                                              ),
                                            ),
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.message,
                                                color: Colors.yellow,
                                              ),
                                              onPressed: () {
                                                // Define the action when the button is pressed
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                              width:
                                                  8), // Space between the icons
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape
                                                  .circle, // Circular shape
                                              border: Border.all(
                                                color: Colors
                                                    .grey, // Black border color
                                                width: 2, // Border width
                                              ),
                                            ),
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.local_phone,
                                                color: Colors.yellow,
                                              ),
                                              onPressed: () {
                                                // Define the action when the button is pressed
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height:
                                    130, // Set the desired height for the Row
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        const Image(
                                          image: AssetImage(
                                              'assets/icons/location1.png'),
                                          width: 25,
                                          height: 25,
                                        ),
                                        CustomPaint(
                                          size: const Size(1, 60),
                                          painter: DashedLineVerticalPainter(),
                                        ),
                                        const Image(
                                          image: AssetImage(
                                              'assets/icons/location2.png'),
                                          width: 25,
                                          height: 25,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Vị trí bắt đầu",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                widget.socketMsg!
                                                        .pickupAddress ??
                                                    '',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Vị trí kết thúc",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                widget.socketMsg!
                                                        .destinationAddress ??
                                                    '',
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.yellow),
                                ),
                                child: ConfirmButton(
                                    onPressed: () =>
                                        {doesStartRoute = true, startRoute()},
                                    text: "Bắt đầu chuyến đi"),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                Positioned(
                  right: 16,
                  bottom: 400,
                  child: Container(
                      decoration: BoxDecoration(
                        color: context.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.near_me,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          // Định nghĩa hành động khi nút được nhấn
                        },
                      )),
                ),
                Positioned(
                  left: 16,
                  top: context.statusBarHeight + 16,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: radius(100),
                        border: Border.all(
                            color: context.scaffoldBackgroundColor, width: 2),
                      ),
                      child: Image.asset(
                        'assets/profile.jpg',
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ).cornerRadiusWithClipRRect(100).onTap(() {
                        jcbHomekey.currentState!.openDrawer();
                      }, borderRadius: radius(100))),
                )
              ],
            ),
    );
  }
}
