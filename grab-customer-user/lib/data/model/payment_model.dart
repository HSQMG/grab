import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  static String collectionName = 'payments';

  PaymentModel({
    required this.id,
    required this.rideId, 
    required this.paymentMethodId, 
    required this.amount,
    required this.promotionId,
    required this.createdAt,
  });

  String id;
  String rideId; 
  String paymentMethodId; // Reference to PaymentMethodModel
  double amount;
  String? promotionId; 
  Timestamp createdAt;

  static PaymentModel fromJson(Map<String, dynamic> map) {
    return PaymentModel(
      id: map["id"],
      rideId: map["rideId"],
      paymentMethodId: map["paymentMethodId"],
      amount: map["amount"] as double,
      promotionId: map["promotionId"],
      createdAt: map["createdAt"] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "rideId": rideId,
      "paymentMethodId": paymentMethodId,
      "amount": amount,
      "promotionId": promotionId,
      "createdAt": createdAt,
    };
  }
}
