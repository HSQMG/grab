import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grab/data/model/address_model.dart';

class ServiceModel {
  static String collectionName = 'services';
  ServiceModel(
      {required this.name,
      required this.id,
      required this.description,
      required this.pricePerKm,
      required this.pricePerMin,
      required this.minimunFare,
      this.createdAt,
      this.updatedAt,
      this.isDeleted = false});
  String id;
  String name;
  String description;
  double pricePerKm;
  double pricePerMin;
  double minimunFare;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  AddressModel? address;
  bool isDeleted;

  static ServiceModel fromJson(Map<String, dynamic> map) {
    return ServiceModel(
      id: map["id"],
      name: map["name"],
      description: map["description"],
      pricePerKm: map["pricePerKm"] as double,
      pricePerMin: map["pricePerMin"] as double,
      minimunFare: map["minimunFare"]  as double,
      createdAt: map["createdAt"] as Timestamp?,
      updatedAt: map["updatedAt"] as Timestamp?,
      isDeleted: map["isDeleted"] as bool,
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "pricePerKm": pricePerKm,
      "minimunFare": minimunFare,
      "pricePerMin": pricePerMin,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "isDeleted": isDeleted,
    };
  }
}
