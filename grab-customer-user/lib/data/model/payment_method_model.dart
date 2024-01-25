
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentMethodModel {
  static String collectionName = 'payment_methods';

  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
  });

  String id;
  String name;
  String description;
  Timestamp createdAt;
  Timestamp updatedAt;
  bool isDeleted;

  static PaymentMethodModel fromJson(Map<String, dynamic> map) {
    return PaymentMethodModel(
      id: map["id"],
      name: map["name"],
      description: map["description"],
      createdAt: map["createdAt"] as Timestamp,
      updatedAt: map["updatedAt"] as Timestamp,
      isDeleted: map["isDeleted"] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "isDeleted": isDeleted,
    };
  }
}
