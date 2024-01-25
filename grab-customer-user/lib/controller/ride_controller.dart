import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grab/config/injection.dart';
import 'package:grab/data/model/address_model.dart';
import 'package:grab/data/model/feedback_model.dart';
import 'package:grab/data/model/ride_model.dart';
import 'package:grab/data/model/socket_msg_model.dart';
import 'package:grab/data/repository/ride_repository.dart';

class RideController {
  final RideRepository rideRepo = getIt.get<RideRepository>();

  Future<String> createRide(SocketMsgModel msg,
      {RideStatus rideStatus = RideStatus.waiting}) async {
    RideModel ride = RideModel(
      customerId: msg.customerId as String,
      driverId: msg.driverId,
      serviceId: msg.service as String,
      startLocation: AddressModel(
          coordinates:
              GeoPoint(msg.pickupPoint!.latitude, msg.pickupPoint!.longitude),
          stringName: msg.pickupAddress as String),
      endLocation: AddressModel(
          coordinates: GeoPoint(
              msg.destinationPoint!.latitude, msg.destinationPoint!.longitude),
          stringName: msg.destinationAddress as String),
      startTime: Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch),
      endTime: Timestamp.fromMillisecondsSinceEpoch(
          DateTime.now().millisecondsSinceEpoch),
      fare: msg.price!.toDouble(),
      status: rideStatus,
      feedback: null,
    );
    return rideRepo.createRide(ride);
  }

  Future<void> updateStatusById(String id, RideStatus status) async {
    rideRepo.updateStatusById(id, status);
  }

  Future<void> updateFareById(String id, int fare) async {
    rideRepo.updateFareById(id, fare);
  }

  Future<void> updateFeedBackById(String id, FeedbackModel feedback) async {
    rideRepo.updateFeedBackById(id, feedback);
  }
}
