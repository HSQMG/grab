import 'package:cloud_firestore/cloud_firestore.dart';

class PromotionModel {
  static String collectionName = 'promotions';

  PromotionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.percent,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String name;
  String description;
  Timestamp startDate;
  Timestamp endDate;
  double percent;
  bool isDeleted; 
  Timestamp createdAt;
  Timestamp updatedAt;

  static PromotionModel fromJson(Map<String, dynamic> map) {
    return PromotionModel(
      id: map["id"],
      name: map["name"],
      description: map["description"],
      startDate: map["startDate"] as Timestamp,
      endDate: map["endDate"] as Timestamp,
      percent: map["percent"] as double,
      isDeleted: map["isDeleted"] as bool, // Use camelCase here
      createdAt: map["createdAt"] as Timestamp,
      updatedAt: map["updatedAt"] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "startDate": startDate,
      "endDate": endDate,
      "percent": percent,
      "isDeleted": isDeleted, 
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }
}
