// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:grab/controller/auth_controller.dart';
import 'package:grab/data/model/ride_model.dart';
import 'package:grab/data/repository/ride_repository.dart';
import 'package:grab/presentations/widget/ride_carts.dart';

class MyRidesScreen extends StatefulWidget {
  const MyRidesScreen({super.key});

  @override
  _MyRidesScreenState createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> {
  final RideRepository rideRepository = RideRepository();
  List<RideModel> rideList = [];
   AuthController authController = Get.find();
   

  @override
  void initState() {
    super.initState();
    fetchAllRides(); // Fetch all rides when the screen initializes
  }

  Future<void> fetchAllRides() async {
    try {
      // Call the readRides function from the repository
      Stream<List<RideModel>> rideStream = rideRepository.readCustomerRides(authController.customer!.id);

      // Listen to the stream and update the rideList when data changes
      rideStream.listen((List<RideModel> rides) {
        setState(() {
          rideList = rides;
        });
      });
    } catch (error) {
      // Handle errors, if any
      debugPrint('Error fetching rides: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<RideModel> completedRides =
        rideList.where((ride) => ride.status == RideStatus.completed).toList();
    List<RideModel> upcomingRides = rideList
        .where((ride) =>
            ride.status == RideStatus.waiting ||
            ride.status == RideStatus.moving)
        .toList();
    List<RideModel> canceledRides =
        rideList.where((ride) => ride.status == RideStatus.cancel).toList();
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Chuyến xe của tôi",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              
              // style: _theme.textTheme.title,
            ),
            SizedBox(
              height: 15.0,
            ),
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TabBar(
                      unselectedLabelColor: Colors.grey,
                      labelColor: theme.primaryColor,
                      labelStyle: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                      indicatorColor: theme.primaryColor,
                      tabs: <Widget>[
                        Tab(
                          text: "ĐANG ĐẾN",
                        ),
                        Tab(
                          text: "ĐÃ ĐẾN",
                        ),
                        Tab(
                          text: "ĐÃ HỦY",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          RideCards(rideList: upcomingRides),
                          RideCards(rideList: completedRides),
                          RideCards(rideList: canceledRides),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
