import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grab/data/model/customer_model.dart';

class CustomerRepository {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Read all customers
  Stream<List<CustomerModel>> readCustomers() {
    return _firestore.collection(CustomerModel.collectionName)
      .snapshots()
      .map((snapshot) => snapshot.docs
        .map((doc) => CustomerModel.fromJson(doc.data()))
        .toList());
  }

  /// Read a specific customer by ID
  Future<CustomerModel?> readCustomer(String id) async {
    final docSnapshot = await _firestore.collection(CustomerModel.collectionName).doc(id).get();
    if (docSnapshot.exists && !docSnapshot.data()!['isDeleted']) {
      return CustomerModel.fromJson(docSnapshot.data()!);
    } else {
      return null;
    }
  }

  /// Create a new customer
  Future<void> createCustomer(CustomerModel customer) async {
    final docRef = _firestore.collection(CustomerModel.collectionName).doc(customer.id);
    await docRef.set(customer.toJson());
  }

  /// Update a customer
  Future<void> updateCustomer(CustomerModel customer) async {
    final docRef = _firestore.collection(CustomerModel.collectionName).doc(customer.id);
    await docRef.update(customer.toJson());
  }

  /// Delete a customer (soft delete by marking as deleted)
  Future<void> deleteCustomer(String id) async {
    final docRef = _firestore.collection(CustomerModel.collectionName).doc(id);
    await docRef.update({'isDeleted': true});
  }

  /// Additional functions related to customer information, orders, etc. can be added here

}
