import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grab/data/model/payment_method_model.dart';

class PaymentMethodRepository {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  Future<String> createPaymentMethod(PaymentMethodModel paymentMethod) async {
    final docRef = firestore.collection(PaymentMethodModel.collectionName).doc();
    paymentMethod.id = docRef.id;
    await docRef.set(paymentMethod.toJson());
    return docRef.id;
  }

  Future<PaymentMethodModel?> getPaymentMethod(String id) async {
    final docRef = firestore.collection(PaymentMethodModel.collectionName).doc(id);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      final data = snapshot.data();
      return PaymentMethodModel.fromJson(data!);
    } else {
      return null;
    }
  }
Future<List<PaymentMethodModel>> getAvailablePaymentMethods() async {
    final querySnapshot = await firestore
        .collection(PaymentMethodModel.collectionName)
        .where("isDeleted", isEqualTo: false)
        .get();
    return querySnapshot.docs
        .map((doc) => PaymentMethodModel.fromJson(doc.data()))
        .toList();
  }
  Future<List<PaymentMethodModel>> getAllPaymentMethods() async {
    final snapshot = await firestore.collection(PaymentMethodModel.collectionName).get();
    return snapshot.docs
        .map((doc) => PaymentMethodModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> updatePaymentMethod(PaymentMethodModel paymentMethod) async {
    final docRef = firestore.collection(PaymentMethodModel.collectionName).doc(paymentMethod.id);
    await docRef.update(paymentMethod.toJson());
  }

  Future<void> deletePaymentMethod(String id) async {
    final docRef = firestore.collection(PaymentMethodModel.collectionName).doc(id);
    await docRef.delete();
  }
}
