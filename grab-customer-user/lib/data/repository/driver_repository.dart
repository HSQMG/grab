import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grab/data/model/driver_model.dart';

class DriverRepository {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Read all drivers
  Stream<List<DriverModel>> readDrivers() {
    return _firestore.collection(DriverModel.collectionName)
      .snapshots()
      .map((snapshot) => snapshot.docs
        .map((doc) => DriverModel.fromJson(doc.data()))
        .toList());
  }

  /// Read a specific driver by ID
  Future<DriverModel?> readDriver(String id) async {
    final docSnapshot = await _firestore.collection(DriverModel.collectionName).doc(id).get();
    if (docSnapshot.exists && !docSnapshot.data()!['isDeleted']) {
      return DriverModel.fromJson(docSnapshot.data()!);
    } else {
      return null;
    }
  }

  /// Create a new driver
  Future<void> createDriver(DriverModel driver) async {
    final docRef = _firestore.collection(DriverModel.collectionName).doc(driver.id);
    await docRef.set(driver.toJson());
  }

  /// Update a driver
  Future<void> updateDriver(DriverModel driver) async {
    final docRef = _firestore.collection(DriverModel.collectionName).doc(driver.id);
    await docRef.update(driver.toJson());
  }

  /// Delete a driver (soft delete by marking as deleted)
  Future<void> deleteDriver(String id) async {
    final docRef = _firestore.collection(DriverModel.collectionName).doc(id);
    await docRef.update({'isDeleted': true});
  }


}
