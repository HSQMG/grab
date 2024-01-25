import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grab/data/model/address_model.dart';

class DriverModel {
  static String collectionName = 'drivers';
  DriverModel(
      {required this.name,
      required this.id,
      required this.phoneNumber,
      required this.licenseNumber,
      required this.email,
      this.address,
      this.createdAt,
      this.updatedAt,
      required this.rating,
      required this.status,
      this.isDeleted = false});
  String id;
  String name;
  String phoneNumber;
  String licenseNumber;
  bool status;
  double rating;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  String email;
  AddressModel? address;
  bool isDeleted;

  static DriverModel fromJson(Map<String, dynamic> map) {
    return DriverModel(
        id: map["id"] ?? "",
        name: map["name"] ?? "",
        email: map["email"] ?? "",
        phoneNumber: map["phoneNumber"] ?? "",
        licenseNumber: map["licenseNumber"] ?? "",
        createdAt:
            map["createdAt"] == null ? null : map["createdAt"] as Timestamp?,
        updatedAt:
            map["updatedAt"] == null ? null : map["updatedAt"] as Timestamp?,
        isDeleted: map["isDeleted"] ?? false,
        address: map["address"] != null
            ? AddressModel.fromJson(map["address"])
            : null, // Use Address.fromJson()
        rating: map['rating'] ?? 0.0,
        status: map['status'] ?? false);
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
      "rating": rating,
      "status": status,
      "licenseNumber": licenseNumber
    };
  }
}
