
import 'package:flutter/material.dart';
import 'package:grab/data/model/ride_model.dart';
import 'package:grab/presentations/widget/ride_cart.dart';


class RideCards extends StatelessWidget {
  final List<RideModel> rideList;
  RideCards({required this.rideList});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rideList.length,
      itemBuilder: (BuildContext context, int index) {
        RideModel ride = rideList[index];
        return RideCard(rideModel: ride);
      },
    );
  }
}
