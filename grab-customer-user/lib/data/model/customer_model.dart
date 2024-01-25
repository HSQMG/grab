import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grab/data/model/address_model.dart';
import 'package:grab/data/model/promotion_model.dart';

class CustomerModel {
  static String collectionName = 'customers';
  CustomerModel({
    required this.name,
    required this.id,
    required this.phoneNumber,
    required this.email,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.isDeleted = false,
    List<PromotionModel>? promotions, // Add list of promotions
  }) : promotions = promotions ?? []; // Initialize promotion list

  String id;
  String name;
  String phoneNumber;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  String email;
  AddressModel? address;
  List<PromotionModel> promotions;
  bool isDeleted;

  static CustomerModel fromJson(Map<String, dynamic> map) {
    return CustomerModel(
      id: map["id"],
      name: map["name"],
      email: map["email"],
      phoneNumber: map["phoneNumber"],
      createdAt: map["createdAt"] as Timestamp?,
      updatedAt: map["updatedAt"] as Timestamp?,
      isDeleted: map["isDeleted"] as bool,
      address: map["address"] != null
          ? AddressModel.fromJson(map["address"])
          : null, // Use Address.fromJson()
      promotions: (map['promotions'] as List<dynamic>?)
              ?.map((e) => PromotionModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "address": address?.toJson(),
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "isDeleted": isDeleted,
      "promotions": promotions.map((e) => e.toJson()).toList(),
    };
  }
}
