import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grab/data/model/vehicle_model.dart';

class VehicleRepository {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> createVehicle(VehicleModel vehicle) async {
    final docRef = firestore.collection(VehicleModel.collectionName).doc();
    vehicle.id = docRef.id;
    await docRef.set(vehicle.toJson());
    return docRef.id;
  }

  Future<VehicleModel?> getVehicle(String id) async {
    final docRef = firestore.collection(VehicleModel.collectionName).doc(id);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      final data = snapshot.data();
      return VehicleModel.fromJson(data!);
    } else {
      return null;
    }
  }

  Future<List<VehicleModel>> getAllVehicles() async {
    final snapshot = await firestore.collection(VehicleModel.collectionName).get();
    return snapshot.docs
        .map((doc) => VehicleModel.fromJson(doc.data()))
        .toList();
  }

  Future<List<VehicleModel>> getActiveVehicles() async {
    final querySnapshot = await firestore
        .collection(VehicleModel.collectionName)
        .where("status", isEqualTo: VehicleStatus.active.name)
        .where("isDeleted", isEqualTo: false)
        .get();
    return querySnapshot.docs
        .map((doc) => VehicleModel.fromJson(doc.data()))
        .toList();
  }

  Future<List<VehicleModel>> getVehiclesByDriver(String driverId) async {
    final querySnapshot = await firestore
        .collection(VehicleModel.collectionName)
        .where("driverId", isEqualTo: driverId)
        .get();
    return querySnapshot.docs
        .map((doc) => VehicleModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> updateVehicle(VehicleModel vehicle) async {
    final docRef = firestore.collection(VehicleModel.collectionName).doc(vehicle.id);
    await docRef.update(vehicle.toJson());
  }

  Future<void> deleteVehicle(String id) async {
    final docRef = firestore.collection(VehicleModel.collectionName).doc(id);
    await docRef.delete();
  }

  Future<void> markVehicleDeleted(String id) async {
    final docRef = firestore.collection(VehicleModel.collectionName).doc(id);
    await docRef.update({ "updatedAt": FieldValue.serverTimestamp(), "isDeleted":true });
  }
}
