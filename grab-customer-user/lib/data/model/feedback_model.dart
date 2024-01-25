import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final int? rating;
  final String comment;
  final Timestamp createdAt;

  FeedbackModel({
    this.rating,
    required this.comment,
    required this.createdAt,
  });
  Map<String, dynamic> toJson() {
    return {
      "rating": rating,
      "comment": comment,
      "createdAt": createdAt,
    };
  }

  static FeedbackModel fromJson(Map<String, dynamic> map) {
    int rating = map["rating"] == null ? 0 : map["rating"] as int;
    return FeedbackModel(
      rating: rating,
      comment: map["comment"],
      createdAt: map["createdAt"] as Timestamp,
    );
  }
}
