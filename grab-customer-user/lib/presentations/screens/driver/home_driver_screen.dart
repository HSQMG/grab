import 'dart:async';
import 'package:grab/data/model/socket_msg_model.dart';
import 'package:grab/presentations/screens/driver/accept_ride_screen.dart';
import 'package:grab/utils/constants/styles.dart';
import 'package:grab/utils/constants/themes.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grab/presentations/widget/profile_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grab/presentations/widget/progress_bar.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final GlobalKey<ScaffoldState> jcbHomekey = GlobalKey();

class HomeDriverScreen extends StatefulWidget {
  const HomeDriverScreen({Key? key}) : super(key: key);

  @override
  State<HomeDriverScreen> createState() => _HomeDriverScreenState();
}

class _HomeDriverScreenState extends State<HomeDriverScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isSwitchedOn = false; // Initial state is "on"
  double currentProgress = 0.0;
  Timer? progressBarTimer;
  SocketMsgModel? socketMsg;
  IO.Socket? socket;
  Position? currentPosition;
  Set<Marker> markers = {};
  final Completer<GoogleMapController> _mapController = Completer();
  String? driverId;
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      currentPosition = position;
      markers.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(title: 'Current Location'),
      ));
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

    socket?.on('connected', (msg) {
      setState(() {
        driverId = msg['id'];
      });
    });

    socket?.on('request_ride', (msg) {
      setState(() {
        socketMsg = SocketMsgModel.fromJson(msg);
        socketMsg?.driverPosition =
            LatLng(currentPosition!.latitude, currentPosition!.longitude);
        socketMsg?.driverId = auth.currentUser?.uid;
        socketMsg?.driverSocketId = driverId;
        if (isSwitchedOn) {
          progressBarTimer?.cancel();
          isSwitchedOn = false;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AcceptRideScreen(
                        socket: socket,
                        socketMsg: socketMsg,
                      )));
        }
      });
      print(msg);
    });

    socket?.onDisconnect((_) => {
          print('Disconnected from server'),
          socket?.emit('user_disconnect', {
            'id': auth.currentUser?.uid,
          })
        });
  }

  void updateProgressBar() {
    const interval = Duration(milliseconds: 10);
    progressBarTimer = Timer.periodic(interval, (timer) {
      if (mounted) {
        setState(() {
          currentProgress = (currentProgress + 1) % 101;
        });
      } else {
        timer.cancel();
        return;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _initializeSocket();
    if (isSwitchedOn) {
      updateProgressBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: jcbHomekey,
        drawer: ProfileHomeScreen(),
        body: SafeArea(
          child: currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          currentPosition!.latitude,
                          currentPosition!.longitude,
                        ),
                        zoom: 15,
                      ),
                      onMapCreated: (controller) =>
                          _mapController.complete(controller),
                      markers: markers,
                    ),
                    Positioned(
                      right: 50,
                      top: MediaQuery.of(context).size.height / 2 - 50,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              20), // You can adjust the radius as needed
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Observer(
                          builder: (_) => GestureDetector(
                            onTap: () {
                              setState(() {
                                isSwitchedOn = !isSwitchedOn;
                                if (isSwitchedOn) {
                                  socket?.connect();
                                  updateProgressBar();
                                } else {
                                  socket?.disconnect();
                                  progressBarTimer?.cancel();
                                }
                              });
                            },
                            child: Image.asset(
                              isSwitchedOn
                                  ? 'assets/icons/on.png'
                                  : 'assets/icons/off.png',
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      right: 20,
                      left: 20,
                      child: Column(children: [
                        Container(
                          alignment: Alignment.bottomCenter,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Center(
                              child: Text(
                            isSwitchedOn
                                ? 'Chế độ nhận chuyến đã được bật'
                                : 'Chế độ nhận chuyến đã tắt',
                            style: MyStyles.boldTextStyle,
                          )),
                        ),
                        const SizedBox(height: 30),
                        isSwitchedOn
                            ? Container(
                                height: 110,
                                alignment: Alignment.bottomCenter,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    const Row(
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/icons/grab_bike.png'),
                                          width: 30,
                                          height: 30,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Text(
                                          "Đang tìm chuyến đi...",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
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
                            : Container(),
                      ]),
                    ),
                    Positioned(
                      left: 16,
                      top: context.statusBarHeight + 16,
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: radius(100),
                            border: Border.all(
                                color: context.scaffoldBackgroundColor,
                                width: 2),
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
        ));
  }
}
