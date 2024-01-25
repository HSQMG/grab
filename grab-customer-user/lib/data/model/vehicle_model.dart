import 'package:cloud_firestore/cloud_firestore.dart';

enum VehicleType { bike, car }

enum VehicleStatus { active, inactive }

class VehicleModel {
  static String collectionName = 'vehicles';

  VehicleModel({
    required this.id,
    required this.driverId, // Reference to DriverModel
    required this.licenseNumber,
    required this.brand,
    required this.model,
    required this.type, // Enum for vehicle type
    required this.status, // Enum for vehicle status
    required this.yearManufactured,
    required this.createdAt,
    required this.updatedAt,
    this.isDeleted = false,
  });

  String id;
  String driverId; // Reference to DriverModel
  String licenseNumber;
  String brand;
  String model;
  VehicleType type; // Enum for vehicle type
  VehicleStatus status; // Enum for vehicle status
  int yearManufactured;
  Timestamp createdAt;
  Timestamp updatedAt;
  bool isDeleted; 

  static VehicleModel fromJson(Map<String, dynamic> map) {
    return VehicleModel(
      id: map["id"],
      driverId: map["driverId"],
      licenseNumber: map["licenseNumber"],
      brand: map["brand"],
      model: map["model"],
      type: VehicleType.values.byName(map["type"]), // Parsing type enum
      status: VehicleStatus.values.byName(map["status"]), // Parsing status enum
      yearManufactured: map["yearManufactured"] as int,
      createdAt: map["createdAt"] as Timestamp,
      updatedAt: map["updatedAt"] as Timestamp,
      isDeleted: map["isDeleted"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "driverId": driverId,
      "licenseNumber": licenseNumber,
      "brand": brand,
      "model": model,
      "type": type.name, 
      "status": status.name, 
      "yearManufactured": yearManufactured,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "isDeleted": isDeleted,
    };
  }
}
