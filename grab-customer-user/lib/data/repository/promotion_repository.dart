import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grab/data/model/promotion_model.dart';

class PromotionRepository {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> createPromotion(PromotionModel promotion) async {
    final docRef = firestore.collection(PromotionModel.collectionName).doc();
    promotion.id = docRef.id;
    await docRef.set(promotion.toJson());
    return docRef.id;
  }

  Future<PromotionModel?> getPromotion(String id) async {
    final docRef = firestore.collection(PromotionModel.collectionName).doc(id);
    final snapshot = await docRef.get();
    if (snapshot.exists) {
      final data = snapshot.data();
      return PromotionModel.fromJson(data!);
    } else {
      return null;
    }
  }

  Future<List<PromotionModel>> getAllPromotions() async {
    final snapshot = await firestore.collection(PromotionModel.collectionName).get();
    return snapshot.docs
        .map((doc) => PromotionModel.fromJson(doc.data()))
        .toList();
  }

  Future<List<PromotionModel>> getActivePromotions() async {
    final querySnapshot = await firestore
        .collection(PromotionModel.collectionName)
        .where("isDeleted", isEqualTo: false)
        .where("endDate", isGreaterThanOrEqualTo: DateTime.now())
        .get();
    return querySnapshot.docs
        .map((doc) => PromotionModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> updatePromotion(PromotionModel promotion) async {
    final docRef = firestore.collection(PromotionModel.collectionName).doc(promotion.id);
    await docRef.update(promotion.toJson());
  }

  Future<void> deletePromotion(String id) async {
    final docRef = firestore.collection(PromotionModel.collectionName).doc(id);
    await docRef.delete();
  }
}
