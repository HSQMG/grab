import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grab/data/model/feedback_model.dart';
import 'package:grab/data/model/ride_model.dart';

class RideRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Read all rides
  Stream<List<RideModel>> readRides() {
    return _firestore.collection(RideModel.collectionName).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => RideModel.fromJson(doc.data()))
            .toList());
  }

  /// Read a specific ride by ID
  Future<RideModel?> readRide(String id) async {
    final docSnapshot =
        await _firestore.collection(RideModel.collectionName).doc(id).get();
    if (docSnapshot.exists) {
      return RideModel.fromJson(docSnapshot.data()!);
    } else {
      return null;
    }
  }

  /// Create a new ride
  Future<String> createRide(RideModel ride) async {
    final docRef = _firestore.collection(RideModel.collectionName).doc();
    ride.id = docRef.id;
    await docRef.set(ride.toJson());
    return ride.id as String;
  }

  /// Update a ride
  Future<void> updateRide(RideModel ride) async {
    final docRef = _firestore.collection(RideModel.collectionName).doc(ride.id);
    await docRef.update(ride.toJson());
  }

  Future<void> updateStatusById(String id, RideStatus status) {
    return _firestore
        .collection(RideModel.collectionName)
        .doc(id)
        .update({'status': status.name});
  }

  Future<void> updateFareById(String id, int fare) {
    return _firestore
        .collection(RideModel.collectionName)
        .doc(id)
        .update({'fare': fare});
  }

  Future<void> updateFeedBackById(String id, FeedbackModel feedback) {
    return _firestore
        .collection(RideModel.collectionName)
        .doc(id)
        .update({'feedback': feedback.toJson()});
  }

  /// Additional functions related to ride status, filtering, etc. can be added here

  /// Read rides for a specific customer
  Stream<List<RideModel>> readCustomerRides(String customerId) {
    return _firestore
        .collection(RideModel.collectionName)
        .where('customerId', isEqualTo: customerId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RideModel.fromJson(doc.data()))
            .toList());
  }

  /// Read rides for a specific driver
  Stream<List<RideModel>> readDriverRides(String driverId) {
    return _firestore
        .collection(RideModel.collectionName)
        .where('driverId', isEqualTo: driverId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RideModel.fromJson(doc.data()))
            .toList());
  }
}
