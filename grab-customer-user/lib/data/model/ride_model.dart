import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grab/data/model/address_model.dart';
import 'package:grab/data/model/feedback_model.dart';

enum RideStatus { cancel, waiting, moving, completed }

class RideModel {
  static String collectionName = 'rides';
  RideModel({
    this.id,
    required this.customerId,
    this.driverId,
    required this.serviceId,
    required this.startLocation,
    required this.endLocation,
    required this.startTime,
    required this.endTime,
    required this.fare,
    required this.status,
    this.feedback,
  });
  String? id;
  String customerId;
  String? driverId;
  String serviceId;
  AddressModel startLocation;
  AddressModel endLocation;
  Timestamp startTime;
  Timestamp endTime;
  double fare;
  RideStatus status;
  FeedbackModel? feedback;

  static RideModel fromJson(Map<String, dynamic> map) {

    return RideModel(
      id: map["id"],
      driverId: map["driverId"],
      customerId: map["customerId"],
      serviceId: map["serviceId"] == null ? map["service"]: map["serviceId"],
      fare: (map["fare"] as num).toDouble() ,
      startLocation: AddressModel.fromJson(map["startLocation"]),
      endLocation: AddressModel.fromJson(map["endLocation"]),
      startTime: map["startTime"] as Timestamp,
      endTime: map["endTime"] as Timestamp,
      status: RideStatus.values.byName(map["status"]),
      feedback: map["feedback"] != null
          ? FeedbackModel.fromJson(map["feedback"])
          : null, // Use Address.fromJson()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "driverId": driverId,
      "customerId": customerId,
      "serviceId": serviceId,
      "fare": fare,
      "startLocation": startLocation.toJson(),
      "endLocation": endLocation.toJson(),
      "startTime": startTime,
      "endTime": endTime,
      "status": status.name,
      "feedback": feedback?.toJson(),
    };
  }
}
