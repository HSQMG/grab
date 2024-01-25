import 'dart:async';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:grab/presentations/screens/search_destination_screen.dart';
import 'package:grab/presentations/widget/profile_home.dart';
import 'package:firebase_auth/firebase_auth.dart';

final GlobalKey<ScaffoldState> jcbHomekey = GlobalKey();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  final FirebaseAuth auth = FirebaseAuth.instance;

  Position? currentPosition;
  Set<Marker> markers = {};
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

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
                    _controller.complete(controller);
                  },
                  markers: markers,
                ),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(20))),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Bạn muốn đi đâu nè',
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Hãy chọn vị trí nhé',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.yellow),
                        ),
                        child: AppTextField(
                          autoFocus: false,
                          textFieldType: TextFieldType.NAME,
                          textStyle: boldTextStyle(),
                          onChanged: (val) {
                            hideKeyboard(context);
                            const SearchDestinationceScreen().launch(context);
                          },
                          onTap: () {
                            hideKeyboard(context);
                            const SearchDestinationceScreen().launch(context);
                          },
                          decoration: InputDecoration(
                            suffixIcon: const Icon(Icons.search_outlined)
                                .paddingAll(12),
                            border: InputBorder.none,
                            hintText: 'Nhập điểm đến',
                            hintStyle: boldTextStyle(
                              color: const Color(0xFF8d9cb2),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 200,
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
