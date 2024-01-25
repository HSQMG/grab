import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grab/data/model/payment_model.dart';

class PaymentRepository {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> createPayment(PaymentModel payment) async {
    final docRef = firestore.collection(PaymentModel.collectionName).doc();
    payment.id = docRef.id;
    await docRef.set(payment.toJson());
    return docRef.id;
  }

  Future<PaymentModel?> getPayment(String id) async {
    final docRef = firestore.collection(PaymentModel.collectionName).doc(id);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      final data = snapshot.data();
      return PaymentModel.fromJson(data!);
    } else {
      return null;
    }
  }

  Future<List<PaymentModel>> getAllPayments() async {
    final snapshot = await firestore.collection(PaymentModel.collectionName).get();
    return snapshot.docs
        .map((doc) => PaymentModel.fromJson(doc.data()))
        .toList();
  }

  Future<List<PaymentModel>> getPaymentsForRide(String rideId) async {
    final querySnapshot = await firestore
        .collection(PaymentModel.collectionName)
        .where("rideId", isEqualTo: rideId)
        .get();
    return querySnapshot.docs
        .map((doc) => PaymentModel.fromJson(doc.data()))
        .toList();
  }

  Future<List<PaymentModel>> getPaymentsByPaymentMethod(String paymentMethodId) async {
    final querySnapshot = await firestore
        .collection(PaymentModel.collectionName)
        .where("paymentMethodId", isEqualTo: paymentMethodId)
        .get();
    return querySnapshot.docs
        .map((doc) => PaymentModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> updatePayment(PaymentModel payment) async {
    final docRef = firestore.collection(PaymentModel.collectionName).doc(payment.id);
    await docRef.update(payment.toJson());
  }

  Future<void> deletePayment(String id) async {
    final docRef = firestore.collection(PaymentModel.collectionName).doc(id);
    await docRef.delete();
  }
  
}
