import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grab/controller/auth_controller.dart';
import 'package:grab/controller/map_controller.dart';
import 'package:grab/controller/ride_controller.dart';
import 'package:grab/data/model/ride_model.dart';
import 'package:grab/data/model/socket_msg_model.dart';
import 'package:grab/presentations/screens/cancle_ride_screen.dart';
import 'package:grab/presentations/screens/feedback_screen.dart';
import 'package:grab/presentations/widget/confirm_button.dart';
import 'package:grab/presentations/widget/progress_bar.dart';
import 'package:grab/state.dart';
import 'package:grab/utils/constants/themes.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class FindDriverScreen extends StatefulWidget {
  const FindDriverScreen({super.key});

  @override
  State<FindDriverScreen> createState() => _FindDriverScreenState();
}

class _FindDriverScreenState extends State<FindDriverScreen> {
  bool isContainerVisible = true;
  late Map<PolylineId, Polyline> _polylines;
  final Completer<GoogleMapController> _mapController = Completer();
  double currentProgress = 0.0;
  Timer? progressBarTimer;
  IO.Socket? socket;
  bool confirmRide = false;
  late Future<List<Object>?> _fetchData;
  bool haveDriver = false;
  LatLng? driverPosition;
  FirebaseAuth auth = FirebaseAuth.instance;
  SocketMsgModel? socketMsg = SocketMsgModel();
  RideController rideController = RideController();
  bool startRide = false;
  @override
  void initState() {
    super.initState();
    _fetchData = _fetchPolylineAndGeoPoints();
    _initializeSocket();
  }

  @override
  void dispose() {
    super.dispose();
    progressBarTimer?.cancel();
  }

  void updateProgressBar() {
    const interval = Duration(milliseconds: 10);
    progressBarTimer = Timer.periodic(interval, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (haveDriver) {
          timer.cancel();
        } else {
          currentProgress = (currentProgress + 1) % 101;
        }
      });
    });
  }

  void _initializeSocket() {
    socket = IO.io(
      'http://192.168.1.46:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket?.onConnect((_) {
      print('Connected to server');
    });

    socket?.on('accept_ride', (msg) {
      socketMsg = SocketMsgModel.fromJson(msg);
      socket?.emit('accept_ride', msg);
      progressBarTimer?.cancel();
      setState(() {
        haveDriver = true;
      });
    });

    socket?.on('start_ride', (msg) {
      setState(() {
        startRide = true;
      });
    });

    socket?.on('finish_ride', (msg) {
      socket?.disconnect();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  FeedBackScreen(msg: socketMsg as SocketMsgModel)));
    });

    GoogleMapController? controller;
    socket?.on('send_location', (msg) async {
      controller ??= await _mapController.future;
      socketMsg = SocketMsgModel.fromJson(msg);
      controller!.moveCamera(CameraUpdate.newLatLng(LatLng(
          socketMsg!.driverPosition!.latitude,
          socketMsg!.driverPosition!.longitude)));
      setState(() {
        driverPosition = LatLng(socketMsg!.driverPosition!.latitude,
            socketMsg!.driverPosition!.longitude);
      });
    });

    socket?.onDisconnect((_) => {
          print('Disconnected from server'),
          socket?.emit('user_disconnect', socketMsg)
        });
  }

  Future<List<Object>?> _fetchPolylineAndGeoPoints() async {
    try {
      var appState = Provider.of<AppState>(context, listen: false);
      List<GeoPoint> geoPoints = await MapController().getGeoPoints(
        appState.pickupAddress.placeId,
        appState.destinationAddress.placeId,
      );
      List<LatLng> polylinePoints = await MapController().getPolylinePoints(
        geoPoints[0],
        geoPoints[1],
      );
      Polyline polyline =
          await MapController().generatePolylineFromPoint(polylinePoints);

      return [geoPoints, polyline];
    } catch (error) {
      print("Error: $error");
      return null;
    }
  }

  Future<void> fitPolylineBounds(List<GeoPoint> geoPoints) async {
    final GoogleMapController controller = await _mapController.future;
    LatLngBounds bounds;
    GeoPoint start = geoPoints[0];
    GeoPoint end = geoPoints[1];

    if (start.latitude > end.latitude) {
      bounds = LatLngBounds(
          northeast: LatLng(start.latitude, start.longitude),
          southwest: LatLng(end.latitude, end.longitude));
    } else {
      bounds = LatLngBounds(
          southwest: LatLng(start.latitude, start.longitude),
          northeast: LatLng(end.latitude, end.longitude));
    }

    LatLng centerBounds = LatLng(
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2);

    controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: centerBounds,
      zoom: 17,
    )));
    bool keepZoomingOut = true;

    while (keepZoomingOut) {
      final LatLngBounds screenBounds = await controller.getVisibleRegion();
      if (fits(bounds, screenBounds)) {
        keepZoomingOut = false;
        final double zoomLevel = await controller.getZoomLevel() - 0.5;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
        break;
      } else {
        final double zoomLevel = await controller.getZoomLevel() - 0.1;
        controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: centerBounds,
          zoom: zoomLevel,
        )));
      }
    }
  }

  void cancelRide() {
    progressBarTimer?.cancel();
    currentProgress = 0;
    socket?.emit('cancel_ride', socketMsg?.toJson());
    socket?.disconnect();
    rideController.updateStatusById(
        socketMsg?.rideId as String, RideStatus.cancel);
    setState(() {
      confirmRide = false;
    });
  }

  void requestRide(
    GeoPoint pickup,
    GeoPoint destination,
    String? destinationAddress,
    String? pickupAddress,
    int price,
    String paymentMethod,
    String? distance,
    String? service,
  ) async {
    socket?.connect();
    confirmRide = true;
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    socketMsg?.customerName = AuthController.instance.customer?.name;
    socketMsg?.customerPhoneNumber =
        AuthController.instance.customer?.phoneNumber;
    socketMsg?.price = price;
    socketMsg?.distance = distance;
    socketMsg?.customerId = user?.uid;
    socketMsg?.customerPosition = LatLng(pickup.latitude, pickup.longitude);
    socketMsg?.destinationAddress = destinationAddress;
    socketMsg?.pickupAddress = pickupAddress;
    socketMsg?.pickupPoint = LatLng(pickup.latitude, pickup.longitude);
    socketMsg?.destinationPoint =
        LatLng(destination.latitude, destination.longitude);
    socketMsg?.paymentMethod = paymentMethod;
    socketMsg?.service = service;
    if (socketMsg?.rideId == null) {
      String id = await rideController.createRide(socketMsg as SocketMsgModel);
      socketMsg?.rideId = id;
    } else {
      await rideController.updateStatusById(
          socketMsg?.rideId as String, RideStatus.waiting);
    }

    socket?.emit('request_ride', socketMsg?.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _fetchData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("Loading...", style: TextStyle(fontSize: 20)),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}",
                  style: const TextStyle(fontSize: 20)),
            );
          } else {
            List<Object>? data = snapshot.data;
            List<GeoPoint> geoPoints = data?[0] as List<GeoPoint>;
            Polyline polyline = data?[1] as Polyline;

            _polylines = <PolylineId, Polyline>{};
            _polylines[polyline.polylineId] = polyline;

            GeoPoint pickup = geoPoints[0];
            GeoPoint destination = geoPoints[1];

            var appState = Provider.of<AppState>(context);

            appState.setDestinationPoint(destination);
            appState.setPickupPoint(pickup);

            Set<Marker> markers = {};
            markers.add(Marker(
              markerId: const MarkerId('currentLocation'),
              position: LatLng(pickup.latitude, pickup.longitude),
              infoWindow: const InfoWindow(title: 'Current Location'),
              icon: BitmapDescriptor.defaultMarkerWithHue(110.0),
            ));

            if (driverPosition != null) {
              markers.add(Marker(
                markerId: const MarkerId('driver'),
                position: driverPosition!,
                infoWindow: const InfoWindow(title: 'Driver'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
              ));
            } else {
              markers.add(Marker(
                markerId: const MarkerId('destination'),
                position: LatLng(destination.latitude, destination.longitude),
                infoWindow: const InfoWindow(title: 'Destination'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
              ));
            }

            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(pickup.latitude, pickup.longitude),
                    zoom: 15,
                  ),
                  polylines: _polylines.values
                      .where((polyline) => driverPosition == null)
                      .toSet(),
                  markers: markers,
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                    fitPolylineBounds(geoPoints);
                  },
                ),
                if (haveDriver == true)
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
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Customer name and number aligned to the left
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          socketMsg?.driverName
                                              as String, // Replace with your dynamic customer name
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          socketMsg?.driverLicense
                                              as String, // Replace with your dynamic customer number
                                          style: const TextStyle(
                                              fontSize: 16, color: Colors.grey),
                                        ),
                                      ],
                                    ),

                                    // Icons aligned to the right
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 2,
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
                                        const SizedBox(width: 8),
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 2,
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
                                        ),
                                      ],
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
                                    const Column(
                                      children: [
                                        SizedBox(height: 25),
                                        Image(
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
                                              const SizedBox(height: 20),
                                              Text(
                                                startRide == false
                                                    ? "Tài xế đang đến đón bạn"
                                                    : "Đang trong chuyến đi",
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                    color: Colors.grey,
                                    onPressed: () => {
                                          socket?.emit('cancel_ride',
                                              socketMsg?.toJson()),
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CancleRideScreen(
                                                          rideId:
                                                              socketMsg?.rideId
                                                                  as String)))
                                        },
                                    text: "Hủy chuyến"),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                      // Visibility widget containing the container
                    ],
                  )
                else if (confirmRide == true && haveDriver == false)
                  Container(
                    height: 110,
                    alignment: Alignment.bottomCenter,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Image(
                              image: AssetImage('assets/icons/grab_bike.png'),
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Expanded(
                                child: Text(
                              "Đang tìm tài xế...",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                              ),
                              child: const Text(
                                'Huỷ chuyến',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                              onPressed: () {
                                cancelRide();
                              },
                            ),
                          ],
                        ),
                        ProgressBar(
                          width: double.infinity,
                          height: 5,
                          color: MyTheme.splash,
                          value: currentProgress / 100,
                        )
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(
                              16.0), // Adjust the padding as needed
                          child: ConfirmButton(
                            onPressed: confirmRide
                                ? null
                                : () {
                                    requestRide(
                                        pickup,
                                        destination,
                                        appState.destinationAddress.stringName,
                                        appState.pickupAddress.stringName,
                                        appState.price,
                                        appState.paymentMethod,
                                        appState.distance,
                                        appState.service);
                                    updateProgressBar();
                                    setState(() {});
                                  },
                            text: "Xác nhận chuyến đi",
                          ),
                        ),
                      ],
                    ),
                  ),
                Positioned(
                  top: 30,
                  left: 20,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          socket?.disconnect();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}

bool fits(LatLngBounds fitBounds, LatLngBounds screenBounds) {
  final bool northEastLatitudeCheck =
      screenBounds.northeast.latitude >= fitBounds.northeast.latitude;
  final bool northEastLongitudeCheck =
      screenBounds.northeast.longitude >= fitBounds.northeast.longitude;

  final bool southWestLatitudeCheck =
      screenBounds.southwest.latitude <= fitBounds.southwest.latitude;
  final bool southWestLongitudeCheck =
      screenBounds.southwest.longitude <= fitBounds.southwest.longitude;

  return northEastLatitudeCheck &&
      northEastLongitudeCheck &&
      southWestLatitudeCheck &&
      southWestLongitudeCheck;
}
