import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grab/data/model/service_model.dart';

class ServiceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Read all services
   Future<List<ServiceModel>> getAllServices() async {
    final snapshot = await _firestore.collection(ServiceModel.collectionName).get();
    return snapshot.docs
        .map((doc) => ServiceModel.fromJson(doc.data()))
        .toList();
  }

  /// Read a specific service by ID
  Future<ServiceModel?> readService(String id) async {
    final docSnapshot =
        await _firestore.collection(ServiceModel.collectionName).doc(id).get();
    if (docSnapshot.exists && !docSnapshot.data()!['isDeleted']) {
      return ServiceModel.fromJson(docSnapshot.data()!);
    } else {
      return null;
    }
  }

  /// Create a new service
  Future<String> createService(ServiceModel service) async {
    final docRef = _firestore.collection(ServiceModel.collectionName).doc();
    service.id = docRef.id;
    await docRef.set(service.toJson());
    return service.id;
  }

  /// Update a service
  Future<void> updateService(ServiceModel service) async {
    final docRef =
        _firestore.collection(ServiceModel.collectionName).doc(service.id);
    await docRef.update(service.toJson());
  }

  /// Delete a service (soft delete by marking as deleted)
  Future<void> deleteService(String id) async {
    final docRef = _firestore.collection(ServiceModel.collectionName).doc(id);
    await docRef.update({'isDeleted': true});
  }

  /// Additional functions related to service details, filtering, etc. can be added here

  /// Get available services (not deleted)
  Stream<List<ServiceModel>> getAvailableServices() {
    return _firestore
        .collection(ServiceModel.collectionName)
        .where('isDeleted', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ServiceModel.fromJson(doc.data()))
            .toList());
  }
}
